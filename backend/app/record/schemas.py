from pydantic import BaseModel, Field
from typing import List, Dict, Optional

class DailyDietRequest(BaseModel):
    username: str = Field(..., description="用户名")
    date: str = Field(..., description="日期，格式为 YYYY-MM-DD")

class FoodItem(BaseModel):
    name: str
    calories: str  # 加单位：例如 "150 卡路里"
    details: str
    imageBase64: Optional[str] = None  # 可选图片字段

class MealInfo(BaseModel):
    time: str
    totalCalories: str  # 也是字符串
    icon: str
    foods: List[FoodItem]

class NutritionSummary(BaseModel):
    calories: str
    protein: str
    fat: str

class DailyDietResponse(BaseModel):
    nutrition: NutritionSummary
    meals: Dict[str, MealInfo]
