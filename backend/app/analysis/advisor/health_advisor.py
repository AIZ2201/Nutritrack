from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import os
import logging
import pymysql
from pymysql.err import MySQLError
from openai import OpenAI

router = APIRouter()

OPENAI_API_KEY  = "sk-31PqbF5zvpyDAbAYB1XrIu6d5eZpdjx3PyvHzM6Vab8RdrGS"

if not OPENAI_API_KEY:
    raise RuntimeError("未设置 OpenAI API Key")

client = OpenAI(api_key=OPENAI_API_KEY, base_url="https://api.chatanywhere.tech/v1")

logging.basicConfig(level=logging.INFO)

class Question(BaseModel):
    username: str
    message: str

def get_db_connection():
    return pymysql.connect(
        host="123.60.149.85",
        user="Login",
        passwd="123456",
        db="login",
        port=3306,
        charset="utf8"
    )

@router.on_event("startup")
def create_chat_log_table():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    CREATE TABLE IF NOT EXISTS ChatLog (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        username VARCHAR(50),
                        user_message TEXT,
                        ai_reply TEXT,
                        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
                    );
                """)
                conn.commit()
        logging.info("ChatLog表已创建或已存在")
    except MySQLError as e:
        logging.error(f"创建ChatLog表失败: {e}")
        raise RuntimeError("数据库初始化失败")

def save_chat_log(username: str, user_message: str, ai_reply: str):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO ChatLog (username, user_message, ai_reply) VALUES (%s, %s, %s)",
                    (username, user_message, ai_reply)
                )
                conn.commit()
    except MySQLError as e:
        logging.warning(f"保存对话失败: {e}")

def get_recent_chat_logs(username: str, limit=6):
    """
    从数据库取最近几轮对话，按时间顺序返回。
    limit=6 意味着最近3轮对话（用户和AI各一条为一轮）
    """
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT user_message, ai_reply FROM ChatLog
                    WHERE username=%s
                    ORDER BY timestamp DESC LIMIT %s
                    """, (username, limit)
                )
                rows = cursor.fetchall()
        rows = list(reversed(rows))  # 按时间顺序排列
        return rows
    except MySQLError as e:
        logging.warning(f"获取历史对话失败: {e}")
        return []

@router.post("/messages")
async def ask_chinese_food_advisor(q: Question):
    if not q.username.strip():
        raise HTTPException(status_code=400, detail="用户名不能为空")
    if not q.message.strip():
        raise HTTPException(status_code=400, detail="问题不能为空")

    # 获取历史对话
    chat_logs = get_recent_chat_logs(q.username, limit=6)

    # 设置 system prompt，根据是否首次对话判断内容
    if not chat_logs:
        messages = [
            {"role": "system", "content": (
                "你是一位专业的 AI 健康顾问，请在首次回复中以'我是你的健康顾问'开头，之后无需再介绍身份。"
            )}
        ]
    else:
        messages = [
            {"role": "system", "content": (
                "你是一位专业的 AI 健康顾问，请直接回答用户的健康问题，不要说明你是谁。"
            )}
        ]

    # 加入历史消息
    for user_msg, ai_reply in chat_logs:
        messages.append({"role": "user", "content": user_msg})
        messages.append({"role": "assistant", "content": ai_reply})

    # 当前用户输入
    messages.append({"role": "user", "content": q.message})

    try:
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
            temperature=0.7,
            max_tokens=500,
            top_p=1,
            frequency_penalty=1,
            presence_penalty=1
        )
        reply = response.choices[0].message.content

        # 保存对话
        save_chat_log(q.username, q.message, reply)

        return {"reply": reply}

    except Exception as e:
        logging.error(f"OpenAI API 调用失败: {e}")
        raise HTTPException(status_code=503, detail=f"OpenAI API 错误：{str(e)}")









