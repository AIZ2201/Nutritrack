from fastapi import FastAPI
from fastapi.testclient import TestClient
from app.register.views import router
from unittest.mock import patch
from datetime import date

# 构建完整 app 并绑定路由
app = FastAPI()
app.include_router(router)
client = TestClient(app)

def test_register_step1_success():
    """
    测试 step=1 注册成功场景
    """
    print("[TEST] 测试 step=1 注册成功")
    with patch("app.register.views.get_user_by_username", return_value=None), \
         patch("app.register.views.add_user_step1", return_value=True):
        request_data = {
            "username": "newuser",
            "password": "newpass",
            "role": "user"
        }
        response = client.post("/register/?step=1", json=request_data)
        assert response.status_code == 200, "step1 注册失败"
        assert response.json()["message"] == "账号注册成功"
        print("[PASS] 注册成功：", response.json())

def test_register_step1_username_exists():
    """
    测试 step=1 用户名已存在处理
    """
    print("[TEST] 测试 step=1 用户名已存在")
    with patch("app.register.views.get_user_by_username", return_value=(1, "newuser", "123", "user")):
        request_data = {
            "username": "newuser",
            "password": "newpass",
            "role": "user"
        }
        response = client.post("/register/?step=1", json=request_data)
        assert response.status_code == 400, "应提示用户名重复"
        assert response.json()["detail"] == "用户名已存在"
        print("[PASS] 用户名重复处理正确：", response.json())

def test_register_step2_success():
    """
    测试 step=2 补充资料成功场景
    """
    print("[TEST] 测试 step=2 补充资料成功")
    with patch("app.register.views.update_user_profile", return_value=True):
        request_data = {
            "username": "newuser",
            "name": "小明",
            "gender": "男",
            "birth_date": str(date(2000, 1, 1)),
            "region": "北京",
            "goal": "减脂",
            "height": 175.0,
            "weight": 70.0,
            "target_weight": 65.0,
            "target_muscle": 35.0,
            "disease": "无",
            "allergy": "无"
        }
        response = client.post("/register/?step=2", json=request_data)
        assert response.status_code == 200, "补充资料失败"
        assert response.json()["message"] == "注册完成"
        print("[PASS] 补充资料成功：", response.json())

def test_register_step2_invalid_data():
    """
    测试 step=2 缺失字段（应报错）
    """
    print("[TEST] 测试 step=2 缺失字段（应报错）")
    with patch("app.register.views.update_user_profile", return_value=True):
        request_data = {
            "username": "newuser",
            "gender": "男",
            "birth_date": str(date(2000, 1, 1)),
            "region": "北京",
            "goal": "减脂"
            # 缺少必填字段 name
        }
        response = client.post("/register/?step=2", json=request_data)
        assert response.status_code == 400, "应因缺字段报错"
        assert "数据格式错误" in response.json()["detail"]
        print("[PASS] 缺字段处理正常：", response.json())

def test_register_step_invalid_step():
    """
    测试非法 step 参数（应报错）
    """
    print("[TEST] 测试非法 step 参数")
    request_data = {
        "username": "newuser",
        "password": "newpass"
    }
    response = client.post("/register/?step=99", json=request_data)
    assert response.status_code == 400, "非法 step 应返回 400"
    assert response.json()["detail"] == "step 参数不合法"
    print("[PASS] 非法 step 处理正常：", response.json())

if __name__ == "__main__":
    print("========== 注册接口测试开始 ==========")
    test_register_step1_success()
    test_register_step1_username_exists()
    test_register_step2_success()
    test_register_step2_invalid_data()
    test_register_step_invalid_step()
    print("========== 所有注册接口测试通过 ==========")
