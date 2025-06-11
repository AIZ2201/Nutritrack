from datetime import datetime

import pymysql
from pymysql.err import MySQLError
import base64

# 整理数据，将从数据库查询到的餐食数据处理成特定格式
def process_meal_data(meal_data, meal_time, userName):
    # 初始化结果字典
    result = {
        "user": userName,  # 用户名
        "meal_time": meal_time,  # 用餐时间
        "foods": [],  # 食物链表（包括单个食物的各种营养信息
        "total": {  # 该餐合计营养信息
            "protein": 0,  # 蛋白质
            "fat": 0,  # 脂肪
            "carbon": 0,  # 碳水
            "calories": 0  # 卡路里
        }
    }
    for row in meal_data:
        # 从数据库查询结果中提取食物信息
        foodName = row[1]
        protein = row[2]
        fat = row[3]
        carbon = row[4]
        calories = row[5]
        pid = row[6]
        data = row[7]
        image_info = None
        if pid is not None and data:
            try:
                # 将图片数据编码为 Base64 格式
                image_base64 = base64.b64encode(data).decode("utf-8")
                image_info = {
                    "pid": pid,
                    "base64": image_base64
                }
            except Exception as e:
                print(f"Error encoding image to base64: {e}")

        # 计算单个食物的总营养
        foodTotal = {
            "protein": protein,  # 蛋白质
            "fat": fat,  # 脂肪
            "carbon": carbon,  # 碳水
            "calories": calories  # 卡路里
        }

        # 将单个食物信息添加到结果列表中
        result["foods"].append({
            "foodName": foodName,  # 食物名称
            "nutrition": foodTotal,  # 营养
            "image": image_info  # 图片
        })

        # 更新该餐的总计营养信息
        for idx in ["protein", "fat", "carbon", "calories"]:
            result["total"][idx] += foodTotal[idx]
    return result

# 创建数据库连接
def get_db_connection():
    try:
        # 建立与 MySQL 数据库的连接
        conn = pymysql.connect(
            host="123.60.149.85",  # 数据库 IP 地址
            user="Login",  # 数据库用户名
            passwd="123456",  # 数据库密码
            db="login",  # 要访问的数据库名
            port=3306,  # MySQL 默认端口
            charset="utf8"
        )
        return conn
    except MySQLError as e:
        print(f"Error connecting to the database: {e}")
        return None

# 获取某食物的信息，这里是获取早餐信息
def get_breakfast_by_userName(userName: str, date: str = None):
    if date is None:
        # 如果未指定日期，则使用当前日期
        date = datetime.now().strftime("%Y-%m-%d")
    # 获取数据库连接
    connection = get_db_connection()
    if connection is None:
        return None
    try:
        # 创建游标对象
        cursor = connection.cursor()
        # 定义 SQL 查询语句
        query = """
            SELECT 
                m.userName, m.foodName, m.protein, m.fat, m.carbon, m.calories, 
                i.pid, i.data 
            FROM meals m
            LEFT JOIN images i ON m.pid = i.pid
            WHERE m.userName = %s AND m.time = '早餐' AND m.day = %s
        """
        # 执行 SQL 查询
        cursor.execute(query, (userName, date))
        # 获取查询结果
        rows = cursor.fetchall()
        # 关闭游标
        cursor.close()
        # 处理查询结果
        return process_meal_data(rows, "早餐", userName)
    except MySQLError as e:
        print(f"Error querying breakfast data: {e}")
        return None
    finally:
        if connection:
            # 关闭数据库连接
            connection.close()

# 获取午餐信息
def get_lunch_by_userName(userName: str, date: str = None):
    if date is None:
        # 如果未指定日期，则使用当前日期
        date = datetime.now().strftime("%Y-%m-%d")
    # 获取数据库连接
    connection = get_db_connection()
    if connection is None:
        return None
    try:
        # 创建游标对象
        cursor = connection.cursor()
        # 定义 SQL 查询语句
        query = """
            SELECT 
                m.userName, m.foodName, m.protein, m.fat, m.carbon, m.calories, 
                i.pid, i.data 
            FROM meals m
            LEFT JOIN images i ON m.pid = i.pid
            WHERE m.userName = %s AND m.time = '午餐' AND m.day = %s
        """
        # 执行 SQL 查询
        cursor.execute(query, (userName, date))
        # 获取查询结果
        rows = cursor.fetchall()
        # 关闭游标
        cursor.close()
        # 处理查询结果
        return process_meal_data(rows, "午餐", userName)
    except MySQLError as e:
        print(f"Error querying lunch data: {e}")
        return None
    finally:
        if connection:
            # 关闭数据库连接
            connection.close()

# 获取晚餐信息
def get_dinner_by_userName(userName: str, date: str = None):
    if date is None:
        # 如果未指定日期，则使用当前日期
        date = datetime.now().strftime("%Y-%m-%d")
    # 获取数据库连接
    connection = get_db_connection()
    if connection is None:
        return None
    try:
        # 创建游标对象
        cursor = connection.cursor()
        # 定义 SQL 查询语句
        query = """
            SELECT 
                m.userName, m.foodName, m.protein, m.fat, m.carbon, m.calories, 
                i.pid, i.data 
            FROM meals m
            LEFT JOIN images i ON m.pid = i.pid
            WHERE m.userName = %s AND m.time = '晚餐' AND m.day = %s
        """
        # 执行 SQL 查询
        cursor.execute(query, (userName, date))
        # 获取查询结果
        rows = cursor.fetchall()
        # 关闭游标
        cursor.close()
        # 处理查询结果
        return process_meal_data(rows, "晚餐", userName)
    except MySQLError as e:
        print(f"Error querying dinner data: {e}")
        return None
    finally:
        if connection:
            # 关闭数据库连接
            connection.close()

# 获取今日餐食信息
def get_current_meal_by_userName(userName: str, date: str = None):
    if date is None:
        # 如果未指定日期，则使用当前日期
        date = datetime.now().strftime("%Y-%m-%d")
    # 获取早餐、午餐和晚餐信息
    breakfast = get_breakfast_by_userName(userName, date)
    lunch = get_lunch_by_userName(userName, date)
    dinner = get_dinner_by_userName(userName, date)

    if breakfast is None or lunch is None or dinner is None:
        return None

    # 计算今日餐食的总计营养信息
    total = {
        "protein": breakfast["total"]["protein"] + lunch["total"]["protein"] + dinner["total"]["protein"],
        "fat": breakfast["total"]["fat"] + lunch["total"]["fat"] + dinner["total"]["fat"],
        "carbon": breakfast["total"]["carbon"] + lunch["total"]["carbon"] + dinner["total"]["carbon"],
        "calories": breakfast["total"]["calories"] + lunch["total"]["calories"] + dinner["total"]["calories"]
    }

    # 构造今日餐食信息结果
    result = {
        "user": userName,
        "meals": {
            "breakfast": breakfast,
            "lunch": lunch,
            "dinner": dinner
        },
        "total": total
    }
    return result

# 以下是测试代码
# print(get_breakfast_by_userName('吴中亚'))
# print(get_lunch_by_userName('吴中亚'))
# print(get_dinner_by_userName('吴中亚'))
# print(get_current_meal_by_userName('testuser'))
# get_db_connection()