from fastapi import APIRouter
from collections import defaultdict
from app.record.schemas import DailyDietRequest, DailyDietResponse, FoodItem, MealInfo, NutritionSummary
from app.record.record_db import fetch_records, fetch_image_base64

router = APIRouter(
    tags=["Diet Record"],
    responses={404: {"description": "Not Found"}}
)

@router.post("/daily", response_model=DailyDietResponse, summary="获取用户某日饮食记录")
async def get_daily_diet_record(request: DailyDietRequest):
    records = fetch_records(request.username, request.date)
    if not records:
        return DailyDietResponse(
            nutrition=NutritionSummary(calories="0", protein="0", fat="0"),
            meals={}
        )

    total_cal = total_pro = total_fat = 0
    grouped_meals = defaultdict(list)

    for rec in records:
        total_cal += int(rec["calories"])
        total_pro += int(rec["protein"])
        total_fat += int(rec["fat"])

        image_base64 = fetch_image_base64(rec["pid"])  # 获取图片 base64

        food = FoodItem(
            name=rec["foodName"],
            calories=f"{rec['calories']} 卡路里",
            details=f"蛋白质: {rec['protein']}g  脂肪: {rec['fat']}g  碳水: {rec['carbon']}g",
            imageBase64=image_base64
        )
        grouped_meals[rec["time"]].append(food)

    meal_response = {}
    for meal_type, foods in grouped_meals.items():
        total = sum(int(float(f.calories.split()[0])) for f in foods)
        icon = "sunny" if meal_type == "早餐" else "restaurant_menu" if meal_type == "午餐" else "dinner_dining"
        time_map = {"早餐": "08:30", "午餐": "12:30", "晚餐": "18:30"}
        meal_response[meal_type] = MealInfo(
            time=time_map.get(meal_type, "00:00"),
            totalCalories=f"{total}",
            icon=icon,
            foods=foods
        )

    return DailyDietResponse(
        nutrition=NutritionSummary(
            calories=str(total_cal),
            protein=str(total_pro),
            fat=str(total_fat)
        ),
        meals=meal_response
    )
