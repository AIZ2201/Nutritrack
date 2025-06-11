import pymysql
import base64
from typing import List, Dict, Optional
import os
from pymysql.err import MySQLError

# 创建数据库连接
def get_db_connection():
    """
    获取数据库连接
    :return: 数据库连接对象 或 None
    """
    try:
        # 从环境变量读取数据库配置，若无则使用默认值
        user = os.getenv("MYSQL_USER", "Login")
        password = os.getenv("MYSQL_PASSWORD", "123456")
        host = os.getenv("MYSQL_HOST", "123.60.149.85")
        db = os.getenv("MYSQL_DB", "login")

        connection = pymysql.connect(
            host=host,
            user=user,
            passwd=password,
            db=db,
            port=3306,
            charset="utf8"
        )
        return connection
    except MySQLError as e:
        print(f"[ERROR] 数据库连接失败: {e}")
        return None

def fetch_records(username: str, date: str) -> List[Dict]:
    connection = get_db_connection()
    if connection is None:
        return []

    try:
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            sql = """
                SELECT foodName, protein, fat, carbon, calories, time, pid
                FROM meals
                WHERE userName = %s AND day = %s
            """
            cursor.execute(sql, (username, date))
            return cursor.fetchall()
    finally:
        connection.close()

def fetch_image_base64(pid: int) -> Optional[str]:
    connection = get_db_connection()
    if connection is None:
        return None

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT data FROM images WHERE pid = %s", (pid,))
            result = cursor.fetchone()
            if result and result[0]:
                return f"data:image/png;base64,{base64.b64encode(result[0]).decode('utf-8')}"
            return None
    finally:
        connection.close()
