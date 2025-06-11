import pytest
from fastapi.testclient import TestClient
from fastapi import FastAPI, HTTPException
import pymysql
from app.analysis.analyz_page import router, get_db_connection

# 创建 FastAPI app 并挂载路由
app = FastAPI()
app.include_router(router)
client = TestClient(app)

def test_db_connection_success():
    conn = None
    try:
        conn = get_db_connection()
        assert conn.open, "数据库连接未打开"
    finally:
        if conn:
            conn.close()

def test_db_connection_failure(monkeypatch):
    def fake_connect(*args, **kwargs):
        raise pymysql.err.MySQLError("模拟连接失败")

    monkeypatch.setattr("pymysql.connect", fake_connect)

    with pytest.raises(HTTPException) as exc_info:
        get_db_connection()

    assert exc_info.value.status_code == 500
    assert "数据库连接失败" in exc_info.value.detail

def test_valid_user():
    response = client.post("/insight", json={"username": "testuser"})
    # 返回可能有多种，主要是状态码是否合理
    assert response.status_code in [200, 400, 404]

def test_missing_username():
    response = client.post("/insight", json={"username": ""})
    assert response.status_code == 400

def test_unknown_user():
    response = client.post("/insight", json={"username": "nonexistent_user_xyz"})
    # 可能返回404用户不存在或200无摄入记录提示
    assert response.status_code in [404, 200]

test_db_connection_success()
test_valid_user()
test_missing_username()
test_unknown_user()



