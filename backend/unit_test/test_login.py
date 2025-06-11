import sys
from pathlib import Path
import asyncio
from fastapi import HTTPException

# 设置路径，确保 app 包可以导入
project_root = Path(__file__).parent.parent.parent
sys.path.append(str(project_root))

from app.auth.login_db_connect import get_db_connection, get_user_by_username
from app.auth.views import login, LoginRequest

def test_database_connection():
    """
    测试数据库是否可以正常连接
    """
    print("[TEST] 测试数据库连接...")
    connection = get_db_connection()
    assert connection is not None, "无法连接到数据库"
    print("[PASS] 数据库连接成功")
    connection.close()

def test_get_existing_user():
    """
    测试是否能正确查询到指定用户
    """
    print("[TEST] 测试是否能查询到用户 'Yishu Wang'...")
    user = get_user_by_username("Yishu Wang")
    assert user is not None, "数据库中找不到用户 'Yishu Wang'"
    assert user[2] == "123456", "用户密码不匹配"
    assert user[3] == "user", "用户角色不正确"
    print("[PASS] 用户查询成功，数据匹配")

async def test_login_success():
    """
    测试 login() 成功登录逻辑
    """
    print("[TEST] 测试 login() 成功登录逻辑...")
    request = LoginRequest(username="Yishu Wang", password="123456")
    result = await login(request)

    # 如果 login 返回 LoginResponse 对象，使用属性访问
    # 如果 login 改成返回 dict，可以改成 result["message"]
    assert result.message == "login_successful", "登录成功但 message 不匹配"
    assert result.role == "user", "登录成功但 role 不匹配"
    print("[PASS] 登录成功逻辑通过")

async def test_login_wrong_password():
    """
    测试 login() 密码错误处理
    """
    print("[TEST] 测试 login() 密码错误逻辑...")
    request = LoginRequest(username="Yishu Wang", password="wrong_pass")
    try:
        await login(request)
        assert False, "密码错误应抛出 HTTPException，但未抛出"
    except HTTPException as e:
        assert e.status_code == 401, "密码错误时返回状态码应为 401"
        assert e.detail == "Invalid username or password", "错误信息不匹配"
        print("[PASS] 密码错误处理正常")

async def test_login_user_not_found():
    """
    测试 login() 用户不存在处理
    """
    print("[TEST] 测试 login() 用户不存在逻辑...")
    request = LoginRequest(username="nouser", password="any")
    try:
        await login(request)
        assert False, "用户不存在时应抛出 HTTPException，但未抛出"
    except HTTPException as e:
        assert e.status_code == 401, "用户不存在时返回状态码应为 401"
        assert e.detail == "Invalid username or password", "错误信息不匹配"
        print("[PASS] 用户不存在处理正常")

if __name__ == "__main__":
    print("====== 开始执行测试 ======\n")

    # 同步测试
    test_database_connection()
    test_get_existing_user()

    # 异步测试
    asyncio.run(test_login_success())
    asyncio.run(test_login_wrong_password())
    asyncio.run(test_login_user_not_found())

    print("\n====== 所有测试通过！ ======")
