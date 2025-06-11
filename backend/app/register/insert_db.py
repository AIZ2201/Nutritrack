import pymysql
from pymysql.err import MySQLError
from app.register.schemas import RegisterStep2

def get_db_connection():
    """
    获取数据库连接对象

    :return: pymysql 连接对象，若连接失败则返回 None
    """
    try:
        return pymysql.connect(
            host="123.60.149.85",
            user="Login",
            passwd="123456",
            db="login",
            port=3306,
            charset="utf8"
        )
    except MySQLError as e:
        print(f"[ERROR] MySQL 连接失败: {e}")
        return None

def get_user_by_username(username: str):
    """
    根据用户名查询用户信息

    :param username: 用户名
    :return: 用户记录元组，若未找到或查询失败返回 None
    """
    conn = get_db_connection()
    if conn is None:
        return None
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM LoginInfo WHERE Username = %s", (username,))
            return cursor.fetchone()
    except MySQLError as e:
        print(f"[ERROR] 查询用户失败: {e}")
        return None
    finally:
        conn.close()


import logging

# 配置日志记录
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')


def add_user_step1(username: str, password: str, role: str):
    """
    向数据库插入用户账号信息（注册步骤1）
    :param username: 用户名
    :param password: 明文密码，将直接存储
    :param role: 用户角色
    :return: True 插入成功，False 失败
    """
    conn = get_db_connection()
    if conn is None:
        return False
    try:
        with conn.cursor() as cursor:
            # 记录密码信息到日志中，供调试使用
            logging.debug(f"Password being stored (plain text): {password}")

            # 直接存储明文密码，不进行任何加密处理
            cursor.execute(
                "INSERT INTO LoginInfo (Username, Password, Role) VALUES (%s, %s, %s)",
                (username, password, role)
            )
            conn.commit()
            return True
    except MySQLError as e:
        logging.error(f"[ERROR] 插入用户失败: {e}")
        return False
    finally:
        conn.close()

def update_user_profile(data: RegisterStep2):
    """
    更新用户个人资料信息（注册步骤2）

    :param data: RegisterStep2 数据模型实例，包含要更新的字段
    :return: True 更新成功，False 失败
    """
    conn = get_db_connection()
    if conn is None:
        return False
    try:
        with conn.cursor() as cursor:
            sql = """
            UPDATE LoginInfo SET 
                Name=%s, Gender=%s, Birth_date=%s, Region=%s, Goal=%s,
                Height=%s, Weight=%s, Target_weight=%s, Target_muscle=%s,
                Disease=%s, Allergy=%s
            WHERE Username=%s
            """
            cursor.execute(sql, (
                data.name, data.gender, data.birth_date, data.region, data.goal,
                data.height, data.weight, data.target_weight, data.target_muscle,
                data.disease, data.allergy, data.username
            ))
            conn.commit()
            return True
    except MySQLError as e:
        print(f"[ERROR] 更新用户信息失败: {e}")
        return False
    finally:
        conn.close()
