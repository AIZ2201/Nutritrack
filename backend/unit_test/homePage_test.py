from unittest.mock import patch

from fastapi.testclient import TestClient
import sys
from pathlib import Path
from app.homePage.homePage_db import process_meal_data, get_breakfast_by_userName

# 获取项目根目录，homePage_db.py 在 app/homePage/ 下，根目录为 Nutritrack
project_root = Path(__file__).parent.parent
# 将项目根目录添加到系统路径中，以便导入其他模块
sys.path.append(str(project_root))
from app.homePage.views import router
# 创建测试客户端，用于模拟对路由的请求
client = TestClient(router)

# 请求体模型示例，包含用户名信息
request_body = {
    "username": "test_user"
}

def test_breakfast():
    # 向 /breakfast 端点发送 POST 请求，并携带请求体
    response = client.post("/breakfast", json=request_body)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 将响应内容解析为 JSON 格式
    data = response.json()
    # 断言返回数据中的用户名与请求的用户名一致
    assert data["userName"] == "test_user"
    # 断言返回数据中的消息为成功获取食物数据
    assert data["message"] == "成功获取食物数据"
    # 断言返回数据中包含早餐信息
    assert "breakfast" in data

def test_lunch():
    # 向 /lunch 端点发送 POST 请求，并携带请求体
    response = client.post("/lunch", json=request_body)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 将响应内容解析为 JSON 格式
    data = response.json()
    # 断言返回数据中的用户名与请求的用户名一致
    assert data["userName"] == "test_user"
    # 断言返回数据中的消息为成功获取食物数据
    assert data["message"] == "成功获取食物数据"
    # 断言返回数据中包含午餐信息
    assert "lunch" in data

def test_dinner():
    # 向 /dinner 端点发送 POST 请求，并携带请求体
    response = client.post("/dinner", json=request_body)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 将响应内容解析为 JSON 格式
    data = response.json()
    # 断言返回数据中的用户名与请求的用户名一致
    assert data["userName"] == "test_user"
    # 断言返回数据中的消息为成功获取食物数据
    assert data["message"] == "成功获取食物数据"
    # 断言返回数据中包含晚餐信息
    assert "dinner" in data

def test_todayMeals():
    # 向 /todayMeals 端点发送 POST 请求，并携带请求体
    response = client.post("/todayMeals", json=request_body)
    # 断言响应状态码为 200，表示请求成功
    assert response.status_code == 200
    # 将响应内容解析为 JSON 格式
    data = response.json()
    # 断言返回数据中的用户名与请求的用户名一致
    assert data["userName"] == "test_user"
    # 断言返回数据中的消息为成功获取食物数据
    assert data["message"] == "成功获取食物数据"
    # 断言返回数据中包含今日餐食信息
    assert "todayMeals" in data

test_todayMeals()
test_breakfast()
test_lunch()
test_dinner()

def test_get_breakfast_by_userName_success():
    # 模拟数据库连接和查询结果
    with patch('homePage.homePage_db.get_db_connection') as mock_get_db_connection:
        mock_connection = mock_get_db_connection.return_value
        mock_cursor = mock_connection.cursor.return_value
        mock_rows = [
            ('testuser', 'food1', 10, 5, 20, 150, 1, b'image_data'),
            ('testuser', 'food2', 5, 2, 10, 80, 2, b'image_data')
        ]
        mock_cursor.fetchall.return_value = mock_rows

        result = get_breakfast_by_userName('testuser')

        # 验证数据库连接和查询操作
        mock_get_db_connection.assert_called_once()
        mock_connection.cursor.assert_called_once()
        mock_cursor.execute.assert_called_once()
        mock_cursor.fetchall.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()

        # 验证结果是否符合预期
        expected_result = process_meal_data(mock_rows, "早餐", "testuser")
        assert result == expected_result

def test_get_breakfast_by_userName_db_connection_failure():
    # 模拟数据库连接失败
    with patch('homePage.homePage_db.get_db_connection') as mock_get_db_connection:
        mock_get_db_connection.return_value = None

        result = get_breakfast_by_userName('testuser')

        # 验证数据库连接操作
        mock_get_db_connection.assert_called_once()

        # 验证结果为 None
        assert result is None

def test_get_breakfast_by_userName_no_data():
    # 模拟查询结果为空
    with patch('homePage.homePage_db.get_db_connection') as mock_get_db_connection:
        mock_connection = mock_get_db_connection.return_value
        mock_cursor = mock_connection.cursor.return_value
        mock_cursor.fetchall.return_value = []

        result = get_breakfast_by_userName('testuser')

        # 验证数据库连接和查询操作
        mock_get_db_connection.assert_called_once()
        mock_connection.cursor.assert_called_once()
        mock_cursor.execute.assert_called_once()
        mock_cursor.fetchall.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()

        # 验证结果是否符合预期
        expected_result = process_meal_data([], "早餐", "testuser")
        assert result == expected_result

