import base64

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, field_validator
from .records_db import get_currentday_meal_by_userName_and_date, get_breakfast_by_userName_and_date, get_dinner_by_userName_and_date, get_lunch_by_userName_and_date
from .records_db import upload_food

# 创建一个 APIRouter 实例，用于定义和组织路由
router = APIRouter()

# 请求体模型，用于验证获取餐食数据接口的请求体
class recordRequest(BaseModel):
    username: str
    date: str

    # 验证用户名不为空
    @field_validator('username')
    def username_not_empty(cls, v):
        if not v.strip():
            raise ValueError('用户名不能为空')
        return v

    # 验证日期不为空
    @field_validator('date')
    def date_not_empty(cls, v):
        if not v.strip():
            raise ValueError('日期不能为空')
        return v

# 定义 /breakfast 接口，用于获取早餐数据
@router.post("/breakfast")
async def breakfast(request: recordRequest):
    try:
        # 从请求体中获取用户名和日期
        username = request.username
        date = request.date
        # 调用 records_db 模块中的函数，获取指定用户在指定日期的早餐数据
        breakfast = get_breakfast_by_userName_and_date(username, date)

        # 如果未找到早餐数据，抛出 404 异常
        if breakfast is None:
            raise HTTPException(status_code=404, detail="未找到早餐数据")

        # 构建响应数据
        response_data = {
            "userName": username,
            "date": date,
            "message": "成功获取食物数据",
            "breakfast": breakfast,
        }
        return response_data
    except Exception as e:
        # 如果出现异常，抛出 500 异常，并包含错误信息
        raise HTTPException(status_code=500, detail=f"获取早餐数据时出错: {str(e)}")

# 定义 /lunch 接口，用于获取午餐数据
@router.post("/lunch")
async def lunch(request: recordRequest):
    try:
        # 从请求体中获取用户名和日期
        username = request.username
        date = request.date
        # 调用 records_db 模块中的函数，获取指定用户在指定日期的午餐数据
        lunch = get_lunch_by_userName_and_date(username, date)

        # 如果未找到午餐数据，抛出 404 异常
        if lunch is None:
            raise HTTPException(status_code=404, detail="未找到午餐数据")

        # 构建响应数据
        response_data = {
            "userName": username,
            "date": date,
            "message": "成功获取食物数据",
            "lunch": lunch,
        }
        return response_data
    except Exception as e:
        # 如果出现异常，抛出 500 异常，并包含错误信息
        raise HTTPException(status_code=500, detail=f"获取午餐数据时出错: {str(e)}")

# 定义 /dinner 接口，用于获取晚餐数据
@router.post("/dinner")
async def dinner(request: recordRequest):
    try:
        # 从请求体中获取用户名和日期
        username = request.username
        date = request.date
        # 调用 records_db 模块中的函数，获取指定用户在指定日期的晚餐数据
        dinner = get_dinner_by_userName_and_date(username, date)

        # 如果未找到晚餐数据，抛出 404 异常
        if dinner is None:
            raise HTTPException(status_code=404, detail="未找到晚餐数据")

        # 构建响应数据
        response_data = {
            "userName": username,
            "date": date,
            "message": "成功获取食物数据",
            "dinner": dinner,  # 修正此处的键名，原来是 "breakfast"
        }
        return response_data
    except Exception as e:
        # 如果出现异常，抛出 500 异常，并包含错误信息
        raise HTTPException(status_code=500, detail=f"获取晚餐数据时出错: {str(e)}")

# 定义 /currentMeals 接口，用于获取全天餐食数据
@router.post("/currentMeals")
async def currentMeals(request: recordRequest):
    try:
        # 从请求体中获取用户名和日期
        username = request.username
        date = request.date

        # 调用 records_db 模块中的函数，获取指定用户在指定日期的全天餐食数据
        todayMeals = get_currentday_meal_by_userName_and_date(username, date)

        # 如果未找到全天餐食数据，抛出 404 异常
        if todayMeals is None:
            raise HTTPException(status_code=404, detail="未找到当日餐食数据")

        # 构建响应数据
        response_data = {
            "userName": username,
            "date": date,
            "message": "成功获取食物数据",
            "todayMeals": todayMeals,
        }
        return response_data
    except Exception as e:
        # 如果出现异常，抛出 500 异常，并包含错误信息
        raise HTTPException(status_code=500, detail=f"获取当日餐食数据时出错: {str(e)}")

# 上传请求体模型，用于验证上传食物数据接口的请求体
class uploadRequest(BaseModel):
    username: str
    foodName: str
    protein: float
    fat: float
    carbon: float
    calories: float
    time: str
    image_base64: str

# 定义 /upload 接口，用于上传食物数据
@router.post("/upload")
async def upload(request: uploadRequest):
    try:
        # 从请求体中获取用户名、食物名称、营养信息、用餐时间和图片的 base64 编码
        username = request.username
        foodName = request.foodName
        protein = request.protein
        fat = request.fat
        carbon = request.carbon
        calories = request.calories
        time = request.time
        image_base64 = request.image_base64
        # 将图片的 base64 编码解码为二进制数据
        image_data = base64.b64decode(image_base64)

        # 调用 records_db 模块中的函数，上传食物数据
        upload_food(username, foodName, protein, fat, carbon, calories, time, image_data)

        # 构建响应数据
        response_data = {
            "userName": username,
            "message": "数据上传成功",
            "time": time,
        }
        return response_data
    except Exception as e:
        # 如果出现异常，抛出 500 异常，并包含错误信息
        print("error!")
        raise HTTPException(status_code=500, detail=f"上传数据时出错: {str(e)}")