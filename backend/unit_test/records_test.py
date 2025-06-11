from fastapi.testclient import TestClient
import base64
import io
from PIL import Image
import sys
from pathlib import Path

# 获取项目根目录，records_db.py 在 app/records/ 下，根目录为 Nutritrack
project_root = Path(__file__).parent.parent

# 将项目根目录添加到系统路径中，以便导入其他模块

sys.path.append(str(project_root))
from app.records.views import router
# 创建测试客户端，用于模拟对路由的请求
client = TestClient(router)


# 测试获取早餐数据的接口
def test_breakfast():
    # 定义请求体，包含用户名和日期，用于向 /breakfast 接口发送请求
    request_data = {
        "username": "testuser",
        "date": "2025-06-06"
    }
    # 发送 POST 请求到 /breakfast 接口，并传递请求体
    response = client.post("/breakfast", json=request_data)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 断言响应中包含正确的用户名
    assert response.json()["userName"] == "testuser"
    # 断言响应中包含成功消息
    assert response.json()["message"] == "成功获取食物数据"

# 测试获取午餐数据的接口
def test_lunch():
    # 定义请求体，包含用户名和日期，用于向 /lunch 接口发送请求
    request_data = {
        "username": "testuser",
        "date": "2025-06-06"
    }
    # 发送 POST 请求到 /lunch 接口，并传递请求体
    response = client.post("/lunch", json=request_data)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 断言响应中包含正确的用户名
    assert response.json()["userName"] == "testuser"
    # 断言响应中包含成功消息
    assert response.json()["message"] == "成功获取食物数据"

# 测试获取晚餐数据的接口
def test_dinner():
    # 定义请求体，包含用户名和日期，用于向 /dinner 接口发送请求
    request_data = {
        "username": "testuser",
        "date": "2025-06-06"
    }
    # 发送 POST 请求到 /dinner 接口，并传递请求体
    response = client.post("/dinner", json=request_data)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 断言响应中包含正确的用户名
    assert response.json()["userName"] == "testuser"
    # 断言响应中包含成功消息
    assert response.json()["message"] == "成功获取食物数据"

# 测试获取全天餐食数据的接口
def test_currentMeals():
    # 定义请求体，包含用户名和日期，用于向 /currentMeals 接口发送请求
    request_data = {
        "username": "testuser",
        "date": "2025-06-06"
    }
    # 发送 POST 请求到 /currentMeals 接口，并传递请求体
    response = client.post("/currentMeals", json=request_data)
    print(f"响应内容: {response.json()}")  # 添加日志
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 断言响应中包含正确的用户名
    assert response.json()["userName"] == "testuser"
    # 断言响应中包含成功消息
    assert response.json()["message"] == "成功获取食物数据"

# 测试上传食物数据的接口
def test_upload():
    # 打开一张图片并转换为 base64 编码
    # 读取本地的 apple.png 图片文件
    image = Image.open("apple.png")
    # 创建一个字节流对象，用于存储图片数据
    image_bytes = io.BytesIO()
    # 将图片以 PNG 格式保存到字节流对象中
    image.save(image_bytes, format='PNG')
    # 从字节流对象中获取图片的二进制数据
    image_binary_data = image_bytes.getvalue()
    image_base64 = base64.b64encode(image_binary_data).decode('utf-8')
    # 定义请求体，包含用户名、食物名称、营养信息、用餐时间和图片的 base64 编码
    request_data = {
        "username": "testuser",
        "foodName": "测试食物苹果",
        "protain": 10.0,
        "fat": 5.0,
        "carbon": 20.0,
        "calorie": 150.0,
        "time": "早餐",
        "image_base64": image_base64
    }
    # 发送 POST 请求到 /upload 接口，并传递请求体
    response = client.post("/upload", json=request_data)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 断言响应中包含正确的用户名
    assert response.json()["userName"] == "testuser"
    # 断言响应中包含成功消息
    assert response.json()["message"] == "数据上传成功"

test_lunch()
test_dinner()
test_breakfast()
test_upload()
test_currentMeals()