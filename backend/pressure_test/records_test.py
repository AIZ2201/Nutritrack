from locust import HttpUser, task, between
import random
import base64
from datetime import datetime

# 示例测试用户数据（你可以用 CSV 方式导入真实数据）
usernames = ["user1", "user2", "user3"]
date = datetime.now().strftime("%Y-%m-%d")

# 伪造一张图片（base64 编码的最小透明 PNG）
FAKE_IMAGE_BASE64 = (
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII="
)

class FoodUser(HttpUser):
    wait_time = between(1, 3)

    @task(2)
    def get_meals(self):
        username = random.choice(usernames)

        for endpoint in ["/breakfast", "/lunch", "/dinner", "/currentMeals"]:
            self.client.post(f"/records{endpoint}", json={
                "username": username,
                "date": date
            })

    @task(1)
    def upload_food(self):
        username = random.choice(usernames)
        food_name = random.choice(["苹果", "香蕉", "葡萄", "牛奶"])
        time_tag = random.choice(["早餐", "午餐", "晚餐"])

        self.client.post("/records/upload", json={
            "username": username,
            "foodName": food_name,
            "protein": round(random.uniform(1, 10), 1),
            "fat": round(random.uniform(1, 10), 1),
            "carbon": round(random.uniform(1, 10), 1),
            "calories": round(random.uniform(20, 100), 1),
            "time": time_tag,
            "image_base64": FAKE_IMAGE_BASE64
        })
