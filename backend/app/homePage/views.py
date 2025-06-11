from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, field_validator
# 引入数据库查询函数
from .homePage_db import get_lunch_by_userName, get_breakfast_by_userName, get_dinner_by_userName, \
    get_current_meal_by_userName

# 创建一个 APIRouter 实例，用于定义路由
router = APIRouter()

# 请求体模型，定义请求体的结构
class HomePageRequest(BaseModel):
    username: str
    date: str | None = None  #新增字段：用于指定查询日期

    # 验证用户名不为空
    @field_validator('username')
    def username_not_empty(cls, v):
        if not v.strip():
            raise ValueError('用户名不能为空')
        return v

    # 验证日期不为空（若传入）
    @field_validator('date')
    def date_not_empty(cls, v):
        if v is not None and not v.strip():
            raise ValueError('日期不能为空')
        return v

# 定义 /breakfast 端点的 POST 请求处理函数
@router.post("/breakfast")
async def breakfast(request: HomePageRequest):
    username = request.username
    try:
        breakfast = get_breakfast_by_userName(username)
        if breakfast is None:
            raise HTTPException(status_code=404, detail="未找到早餐数据")
        response_data = {
            "userName": username,
            "message": "成功获取食物数据",
            "breakfast": breakfast,
        }
        return response_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取早餐数据时出现错误: {str(e)}")

# 定义 /lunch 端点的 POST 请求处理函数
@router.post("/lunch")
async def lunch(request: HomePageRequest):
    username = request.username
    try:
        lunch = get_lunch_by_userName(username)
        if lunch is None:
            raise HTTPException(status_code=404, detail="未找到午餐数据")
        response_data = {
            "userName": username,
            "message": "成功获取食物数据",
            "lunch": lunch,
        }
        return response_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取午餐数据时出现错误: {str(e)}")

# 定义 /dinner 端点的 POST 请求处理函数
@router.post("/dinner")
async def dinner(request: HomePageRequest):
    username = request.username
    try:
        dinner = get_dinner_by_userName(username)
        if dinner is None:
            raise HTTPException(status_code=404, detail="未找到晚餐数据")
        response_data = {
            "userName": username,
            "message": "成功获取食物数据",
            "dinner": dinner,
        }
        return response_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取晚餐数据时出现错误: {str(e)}")

# 定义 /todayMeals 端点的 POST 请求处理函数，支持传入日期
@router.post("/todayMeals")
async def todayMeals(request: HomePageRequest):
    username = request.username
    date = request.date
    try:
        todayMeals = get_current_meal_by_userName(username, date)
        if todayMeals is None:
            raise HTTPException(status_code=404, detail="未找到指定日期的餐食数据")
        response_data = {
            "userName": username,
            "date": date,
            "message": "成功获取食物数据",
            "todayMeals": todayMeals,
        }
        return response_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取今日餐食数据时出现错误: {str(e)}")
