# mine_test.py
import unittest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

class TestMineModule(unittest.TestCase):

    def setUp(self):
        self.username = "testuser"


    def test_update_name(self):
        new_name = "新昵称"
        response = client.post("/mine/update-name", json={
            "username": self.username,
            "name": new_name
        })
        self.assertEqual(response.status_code, 200)
        self.assertIn("message", response.json())

    def test_update_goal(self):
        response = client.post("/mine/update-goal", json={
            "username": self.username,
            "goal": "减脂",
            "target_weight": 65.0,
            "target_muscle": 20.0
        })
        self.assertEqual(response.status_code, 200)
        self.assertIn("message", response.json())

    def test_update_health(self):
        response = client.post("/mine/update-health", json={
            "username": self.username,
            "height": 175.0,
            "weight": 68.0,
            "birth_date": "1995-01-01",
            "region": "江苏"
        })
        self.assertEqual(response.status_code, 200)
        self.assertIn("message", response.json())

    def test_update_preference(self):
        response = client.post("/mine/update-pref", json={
            "username": self.username,
            "disease": "海鲜",
            "allergy": "高蛋白"
        })
        self.assertEqual(response.status_code, 200)
        self.assertIn("message", response.json())

if __name__ == "__main__":
    unittest.main()
