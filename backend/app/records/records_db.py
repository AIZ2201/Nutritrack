import base64
from datetime import datetime
import sys
from pathlib import Path
from PIL import Image
import io

# 获取项目根目录，records_db.py 在 app/records/ 下，根目录为 Nutritrack
project_root = Path(__file__).parent.parent.parent
# 将项目根目录添加到系统路径中，以便导入其他模块
sys.path.append(str(project_root))
from app.homePage.homePage_db import (
    get_lunch_by_userName,
    get_breakfast_by_userName,
    get_dinner_by_userName,
    get_current_meal_by_userName,
    get_db_connection
)

# 获取某食物的信息 - 早餐
def get_breakfast_by_userName_and_date(userName: str, date: str):
    try:
        # 调用 homePage_db 模块中的函数，获取指定用户在指定日期的早餐数据
        return get_breakfast_by_userName(userName, date)
    except Exception as e:
        # 如果出现异常，打印错误信息并返回 None
        print(f"获取早餐信息时出错: {e}")
        return None

# 获取某食物的信息 - 午餐
def get_lunch_by_userName_and_date(userName: str, date: str):
    try:
        # 调用 homePage_db 模块中的函数，获取指定用户在指定日期的午餐数据
        return get_lunch_by_userName(userName, date)
    except Exception as e:
        # 如果出现异常，打印错误信息并返回 None
        print(f"获取午餐信息时出错: {e}")
        return None

# 获取某食物的信息 - 晚餐
def get_dinner_by_userName_and_date(userName: str, date: str):
    try:
        # 调用 homePage_db 模块中的函数，获取指定用户在指定日期的晚餐数据
        result = get_current_meal_by_userName(userName, date)
        return result
    except Exception as e:
        # 如果出现异常，打印错误信息并返回 None
        print(f"获取晚餐信息时出错: {e}")
        return None

# 获取某食物的信息 - 全天
def get_currentday_meal_by_userName_and_date(userName: str, date: str):
    try:
        # 调用 homePage_db 模块中的函数，获取指定用户在指定日期的全天餐食数据
        return get_current_meal_by_userName(userName, date)
    except Exception as e:
        # 如果出现异常，打印错误信息并返回 None
        print(f"获取全天饮食信息时出错: {e}")
        return None

# 上传图片到数据库
def upload_image(image_data):
    conn = None
    try:
        # 获取数据库连接
        conn = get_db_connection()
        # 创建游标对象
        cursor = conn.cursor()

        # 定义 SQL 插入语句，将图片数据插入到 images 表中
        sql = "INSERT INTO images (data) VALUES (%s)"
        # 执行 SQL 语句
        cursor.execute(sql, (image_data,))
        # 获取插入图片的 ID
        image_id = cursor.lastrowid
        # 提交事务
        conn.commit()
        return image_id
    except Exception as e:
        # 如果出现异常，打印错误信息并回滚事务
        print(f"上传图片时出错: {e}")
        if conn:
            conn.rollback()
        return None
    finally:
        # 关闭数据库连接
        if conn:
            conn.close()

# 上传饮食信息到数据库
def upload_food(userName, foodName, protein, fat, carbon, calories, time, image_data):
    # 调用 upload_image 函数上传图片，并获取图片 ID
    pid = upload_image(image_data)
    if pid is None:
        # 如果图片上传失败，打印错误信息并返回
        print("上传图片失败，无法上传饮食信息")
        return

    conn = None
    try:
        # 获取数据库连接
        conn = get_db_connection()
        # 创建游标对象
        cursor = conn.cursor()
        # 获取当前日期
        day = datetime.now().strftime("%Y-%m-%d")
        # 定义 SQL 插入语句，将饮食信息插入到 meals 表中
        cursor.execute(
            """
            INSERT INTO meals (userName, foodName, protein, fat, carbon, calories, time, day, pid)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (userName, foodName, protein, fat, carbon, calories, time, day, pid)
        )
        # 提交事务
        conn.commit()
    except Exception as e:
        # 如果出现异常，打印错误信息并回滚事务
        print(f"上传饮食信息时出错: {e}")
        if conn:
            conn.rollback()
    finally:
        # 关闭数据库连接
        if conn:
            conn.close()


# 以下是测试代码，用于上传测试数据并获取和显示图片
'''
appleImage = Image.open("C:/Users/75995/Desktop/apple.png")
grapeImage = Image.open("C:/Users/75995/Desktop/grape.png")
bananaImage = Image.open("C:/Users/75995/Desktop/banana.png")
apple_image_bytes = io.BytesIO()
appleImage.save(apple_image_bytes, format='PNG')
apple_image_binary_data = apple_image_bytes.getvalue()
grape_image_bytes = io.BytesIO()
grapeImage.save(grape_image_bytes, format='PNG')
grape_image_binary_data = grape_image_bytes.getvalue()
banana_image_bytes = io.BytesIO()
bananaImage.save(banana_image_bytes, format='PNG')
banana_image_binary_data = banana_image_bytes.getvalue()
upload_food("testuser","苹果",2,2,3,65,"早餐",apple_image_binary_data)
upload_food("testuser","香蕉",6,5,3,54,"午餐",banana_image_binary_data)
upload_food("testuser","苹果",4,4,6,130,"午餐",apple_image_binary_data)
upload_food("testuser","葡萄",7,8,2,33,"晚餐",grape_image_binary_data)

response_data = get_currentday_meal_by_userName_and_date("testuser",datetime.now().strftime("%Y-%m-%d"))
print(datetime.now().strftime("%Y-%m-%d"))
image_data = base64.b64decode(response_data["meals"]["breakfast"]["foods"][0]["image"]["base64"])
image = Image.open(io.BytesIO(image_data))
image.show()
'''
