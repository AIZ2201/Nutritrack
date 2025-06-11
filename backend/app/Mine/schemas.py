from pydantic import BaseModel
from typing import Optional

class UserBase(BaseModel):
    username: str

class UpdateNameRequest(UserBase):
    name: str

class UpdateGoalRequest(UserBase):
    goal: str
    target_weight: Optional[float] = None
    target_muscle: Optional[float] = None

class UpdateHealthRequest(UserBase):
    height: Optional[float] = None
    weight: Optional[float] = None
    birth_date: Optional[str] = None  # 格式: YYYY-MM-DD
    region: Optional[str] = None

class UpdatePreferenceRequest(UserBase):
    disease: Optional[str] = None
    allergy: Optional[str] = None

class UserProfile(BaseModel):
    username: str
    name: Optional[str] = None
    gender: Optional[str] = None
    birth_date: Optional[str] = None
    region: Optional[str] = None
    goal: Optional[str] = None
    height: Optional[float] = None
    weight: Optional[float] = None
    target_weight: Optional[float] = None
    target_muscle: Optional[float] = None
    disease: Optional[str] = None
    allergy: Optional[str] = None
