from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import pymysql
from pymysql.err import MySQLError
from typing import Dict

router = APIRouter()

# 数据模型
class UserQuery(BaseModel):
    username: str

# 数据库配置
DB_CONFIG = {
    "host": "123.60.149.85",
    "user": "Login",
    "passwd": "123456",
    "db": "login",
    "port": 3306,
    "charset": "utf8"
}

# 推荐摄入量
GOAL_RECOMMENDATIONS = {
    "增肌": {"calories": 2800, "protein": 150, "fat": 70, "carbon": 300},
    "减脂减重": {"calories": 1800, "protein": 120, "fat": 50, "carbon": 150},
    "维持体重": {"calories": 2200, "protein": 130, "fat": 60, "carbon": 200},
    "改善消化": {"calories": 2000, "protein": 120, "fat": 70, "carbon": 200},
    "控制疾病": {"calories": 1700, "protein": 100, "fat": 60, "carbon": 300}
}

# 获取数据库连接
def get_db_connection():
    try:
        return pymysql.connect(**DB_CONFIG)
    except MySQLError as e:
        raise HTTPException(status_code=500, detail=f"数据库连接失败: {str(e)}")

@router.post("/insight")
async def analyze_nutrition(query: UserQuery):
    username = query.username.strip()
    if not username:
        raise HTTPException(status_code=400, detail="用户名不能为空")

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # 获取用户目标
        cursor.execute("SELECT goal FROM LoginInfo WHERE username = %s", (username,))
        result = cursor.fetchone()
        if not result:
            raise HTTPException(status_code=404, detail=f"未找到用户 {username} 的目标设定")

        goal = result[0]
        if goal not in GOAL_RECOMMENDATIONS:
            raise HTTPException(status_code=400, detail=f"未知的目标类型: {goal}")

        # 获取所有摄入记录
        cursor.execute("""
            SELECT protein, fat, carbon, calories
            FROM meals
            WHERE username = %s
        """, (username,))
        meals = cursor.fetchall()
        if not meals:
            return {"warning": f"用户 {username} 暂无摄入记录"}

        # 汇总数据
        total = {"protein": 0, "fat": 0, "carbon": 0, "calories": 0}
        for p, f, c, cal in meals:
            total["protein"] += p or 0
            total["fat"] += f or 0
            total["carbon"] += c or 0
            total["calories"] += cal or 0

        target = GOAL_RECOMMENDATIONS[goal]
        analysis: Dict[str, Dict[str, str]] = {}

        for key in ["calories", "protein", "fat", "carbon"]:
            pct = total[key] / target[key] * 100 if target[key] else 0
            if pct < 80:
                status = f"摄入不足，仅达成 {pct:.1f}%"
            elif pct > 120:
                status = f"摄入过多，已超过 {pct:.1f}%"
            else:
                status = f"摄入适中，达成 {pct:.1f}%"
            analysis[key] = {
                "目标": target[key],
                "累计摄入": round(total[key], 1),
                "状态": status
            }

        return {
            "username": username,
            "goal": goal,
            "analysis": analysis
        }

    except MySQLError as e:
        raise HTTPException(status_code=500, detail=f"MySQL 执行错误: {str(e)}")
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass


