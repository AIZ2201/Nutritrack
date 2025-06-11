import pytest
from fastapi.testclient import TestClient
from fastapi import FastAPI
import os

# 模拟设置 OpenAI Key，避免导入时报错
os.environ["OPENAI_API_KEY"] = "fake-api-key-for-test"

from app.analysis.advisor.health_advisor import router

app = FastAPI()
app.include_router(router)
test_client = TestClient(app)

# 模拟 OpenAI 返回内容
def fake_create(*args, **kwargs):
    class FakeResponse:
        choices = [
            type("obj", (), {
                "message": type("msg", (), {
                    "content": "您好，我是您的健康顾问，这是测试回答"
                })()
            })()
        ]
    return FakeResponse()

@pytest.fixture(autouse=True)
def patch_dependencies(monkeypatch):
    # Patch OpenAI 客户端
    from app.analysis.advisor import health_advisor
    monkeypatch.setattr(health_advisor.client.chat.completions, "create", fake_create)

    # Patch 数据库连接，避免触发真实数据库连接
    class FakeCursor:
        def execute(self, *args, **kwargs): pass
        def fetchall(self): return []
        def __enter__(self): return self
        def __exit__(self, *args): pass

    class FakeConnection:
        def cursor(self): return FakeCursor()
        def commit(self): pass
        def __enter__(self): return self
        def __exit__(self, *args): pass

    monkeypatch.setattr(health_advisor, "get_db_connection", lambda: FakeConnection())
    yield

def test_messages_valid():
    response = test_client.post("/messages", json={
        "username": "testuser",
        "message": "我应该怎么增肌？"
    })
    assert response.status_code == 200
    data = response.json()
    assert "reply" in data
    assert data["reply"].startswith("您好，我是您的健康顾问")

def test_empty_username_messages():
    response = test_client.post("/messages", json={
        "username": "",
        "message": "问题内容"
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "用户名不能为空"

def test_empty_message_send():
    response = test_client.post("/messages", json={
        "username": "testuser",
        "message": ""
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "问题不能为空"


