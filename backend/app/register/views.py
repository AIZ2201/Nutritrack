from fastapi import APIRouter, HTTPException, Query, Request
from fastapi.responses import JSONResponse
from app.register.insert_db import (
    get_user_by_username,
    add_user_step1,
    update_user_profile
)
from app.register.schemas import RegisterStep2

router = APIRouter(
    tags=["User Registration"],
    responses={404: {"description": "Not Found"}}
)

@router.post(
    "",
    summary="用户注册",
    description="""
    用户注册接口，分两步进行：

    - Step 1：注册账号（用户名、密码、角色）
    - Step 2：完善用户个人资料信息
    """,
    responses={
        200: {"description": "操作成功"},
        400: {"description": "请求参数错误"},
        500: {"description": "服务器内部错误"}
    }
)
async def register(request: Request, step: int = Query(..., description="注册步骤（1 或 2）")):
    """
    用户注册接口（支持分步注册）

    :param request: 请求对象，包含请求体 JSON 数据
    :param step: 注册步骤，1 为账号注册，2 为完善资料
    :return: 成功返回 JSON 消息，否则抛出 HTTPException
    """
    try:
        data = await request.json()
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"请求体格式错误: {e}")

    if step == 1:
        username = data.get("username", "").strip()
        password = data.get("password", "").strip()
        role = data.get("role", "user").strip()

        if not username or not password:
            raise HTTPException(status_code=400, detail="用户名和密码不能为空")

        if get_user_by_username(username):
            raise HTTPException(status_code=400, detail="用户名已存在")

        if add_user_step1(username, password, role):
            return {"message": "账号注册成功"}
        else:
            raise HTTPException(status_code=500, detail="账号注册失败")

    elif step == 2:
        username = data.get("username", "").strip()
        if not username:
            raise HTTPException(status_code=400, detail="用户名不能为空")

        try:
            parsed_data = RegisterStep2(**data)
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"数据格式错误: {e}")

        if update_user_profile(parsed_data):
            return {"message": "注册完成"}
        else:
            raise HTTPException(status_code=500, detail="注册信息更新失败")

    raise HTTPException(status_code=400, detail="step 参数不合法")
