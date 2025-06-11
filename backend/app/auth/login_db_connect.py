import os
import pymysql
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


def get_all_table_data():
    """
    获取 LoginInfo 表中所有数据
    :return: 包含所有记录的列表，查询失败时返回空列表
    """
    connection = get_db_connection()
    if connection is None:
        return []

    try:
        with connection.cursor() as cursor:
            query = "SELECT * FROM LoginInfo"
            cursor.execute(query)
            rows = cursor.fetchall()
            return rows
    except MySQLError as e:
        print(f"[ERROR] 获取 LoginInfo 数据失败: {e}")
        return []
    finally:
        connection.close()


def get_user_by_username(username: str):
    """
    根据用户名查询用户信息
    :param username: 用户名
    :return: 用户记录元组 或 None
    """
    if not username:
        print("[WARNING] 空用户名传入 get_user_by_username")
        return None

    connection = get_db_connection()
    if connection is None:
        return None

    try:
        with connection.cursor() as cursor:
            query = "SELECT * FROM LoginInfo WHERE Username = %s"
            cursor.execute(query, (username,))
            result = cursor.fetchone()
            return result
    except MySQLError as e:
        print(f"[ERROR] 获取用户数据失败: {e}")
        return None
    finally:
        connection.close()
