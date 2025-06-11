from fastapi import APIRouter, HTTPException
from app.Mine import mine_db
from app.Mine.schemas import (
    UserBase, UpdateNameRequest, UpdateGoalRequest,
    UpdateHealthRequest, UpdatePreferenceRequest,
    UserProfile
)

router = APIRouter()

from datetime import date

@router.post("/profile", response_model=UserProfile, summary="获取用户信息")
async def get_profile(request: UserBase):
    user = mine_db.get_user_profile(request.username)
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    # 手动映射字段
    return UserProfile(
        username=user.get("UserName"),
        name=user.get("Name"),
        gender=user.get("Gender"),
        birth_date=user.get("Birth_date").isoformat() if isinstance(user.get("Birth_date"), date) else None,
        region=user.get("Region"),
        goal=user.get("Goal"),
        height=user.get("Height"),
        weight=user.get("Weight"),
        target_weight=user.get("Target_weight"),
        target_muscle=user.get("Target_muscle"),
        disease=user.get("Disease"),
        allergy=user.get("Allergy")
    )


@router.post("/update-name", summary="修改昵称")
async def update_name(req: UpdateNameRequest):
    mine_db.update_field(req.username, "Name", req.name)
    return {"message": "昵称更新成功"}

@router.post("/update-goal", summary="修改健身目标")
async def update_goal(req: UpdateGoalRequest):
    updates = {"Goal": req.goal}
    if req.target_weight is not None:
        updates["Target_weight"] = req.target_weight
    if req.target_muscle is not None:
        updates["Target_muscle"] = req.target_muscle
    mine_db.update_multiple_fields(req.username, updates)
    return {"message": "目标更新成功"}

@router.post("/update-health", summary="修改健康信息")
async def update_health(req: UpdateHealthRequest):
    updates = {}
    if req.height is not None:
        updates["Height"] = req.height
    if req.weight is not None:
        updates["Weight"] = req.weight
    if req.birth_date is not None:
        updates["Birth_date"] = req.birth_date
    if req.region is not None:
        updates["Region"] = req.region
    mine_db.update_multiple_fields(req.username, updates)
    return {"message": "健康信息更新成功"}

@router.post("/update-pref", summary="修改饮食偏好")
async def update_preference(req: UpdatePreferenceRequest):
    updates = {}
    if req.disease is not None:
        updates["Disease"] = req.disease
    if req.allergy is not None:
        updates["Allergy"] = req.allergy
    mine_db.update_multiple_fields(req.username, updates)
    return {"message": "饮食偏好更新成功"}