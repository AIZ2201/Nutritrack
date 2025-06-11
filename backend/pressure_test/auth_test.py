from locust import HttpUser, task, between

class LoginUser(HttpUser):
    wait_time = between(1, 3)  # 每个用户请求间隔时间

    @task
    def login(self):
        self.client.post("/auth/login", json={
            "username": "aimbot",
            "password": "123456"
        })
