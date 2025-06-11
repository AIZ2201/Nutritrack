import pymysql
from pymysql.err import MySQLError

def get_db_connection():
    return pymysql.connect(
        host="123.60.149.85",
        user="Login",
        passwd="123456",
        db="login",
        port=3306,
        charset="utf8"
    )

def get_user_profile(username: str):
    try:
        with get_db_connection() as conn:
            with conn.cursor(pymysql.cursors.DictCursor) as cursor:
                cursor.execute("SELECT * FROM LoginInfo WHERE UserName = %s", (username,))
                result = cursor.fetchone()
                return result
    except MySQLError as e:
        print(f"数据库查询失败: {e}")
        return None

def update_field(username: str, field: str, value):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                sql = f"UPDATE LoginInfo SET {field} = %s WHERE UserName = %s"
                cursor.execute(sql, (value, username))
                conn.commit()
    except MySQLError as e:
        print(f"更新字段 {field} 失败: {e}")

def update_multiple_fields(username: str, updates: dict):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                fields = ", ".join([f"{k} = %s" for k in updates])
                values = list(updates.values()) + [username]
                sql = f"UPDATE LoginInfo SET {fields} WHERE UserName = %s"
                cursor.execute(sql, values)
                conn.commit()
    except MySQLError as e:
        print(f"更新多个字段失败: {e}")