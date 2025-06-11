from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from typing import Any, Dict
from app.auth.login_db_connect import get_user_by_username, get_all_table_data

# 创建 APIRouter 实例
router = APIRouter(
    tags=["Authentication"],  # 接口分类（用于文档）
    responses={404: {"description": "Not found"}}
)

# 请求体模型
class LoginRequest(BaseModel):
    username: str = Field(..., min_length=1, max_length=150, description="用户名")
    password: str = Field(..., min_length=1, max_length=150, description="用户密码")

# 响应模型
class LoginResponse(BaseModel):
    message: str = Field(..., description="登录结果信息")
    role: str = Field(..., description="用户角色")

@router.post(
    "/login",
    response_model=LoginResponse,
    responses={
        200: {"description": "登录成功，返回用户角色"},
        401: {"description": "用户名或密码错误"},
        500: {"description": "服务器内部错误"}
    },
    summary="用户登录",
    description="用户登录接口，验证用户名和密码，返回用户角色信息。"
)
async def login(request: LoginRequest):
    """
    用户登录接口

    - **username**: 用户名
    - **password**: 用户密码
    """
    username = request.username.strip()
    password = request.password.strip()

    # 打印所有用户信息（仅供调试）
    all_users = get_all_table_data()
    print("[INFO] 当前 LoginInfo 表内容：")
    for user in all_users:
        print(user)

    # 查询指定用户信息
    user = get_user_by_username(username)

    # 验证用户信息
    if user:
        db_password = user[2]
        role = user[3]

        if db_password == password:
            return LoginResponse(message="login_successful", role=role)
        else:
            print(f"[WARNING] 用户 {username} 密码错误")
    else:
        print(f"[WARNING] 用户 {username} 不存在")

    raise HTTPException(status_code=401, detail="Invalid username or password")
