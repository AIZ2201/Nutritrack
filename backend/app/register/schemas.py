from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class RegisterStep1(BaseModel):
    username: str = Field(..., description="用户名")
    password: str = Field(..., description="密码")

class RegisterStep2(BaseModel):
    username: str = Field(..., description="用户名")
    name: str = Field(..., description="姓名")
    gender: str = Field(..., description="性别")
    birth_date: date = Field(..., description="出生日期")
    region: str = Field(..., description="地区")
    goal: str = Field(..., description="健身目标")
    height: Optional[float] = Field(None, description="身高(cm)")
    weight: Optional[float] = Field(None, description="体重(kg)")
    target_weight: Optional[float] = Field(None, description="目标体重(kg)")
    target_muscle: Optional[float] = Field(None, description="目标肌肉量(kg)")
    disease: Optional[str] = Field(None, description="疾病史")
    allergy: Optional[str] = Field(None, description="过敏史")
