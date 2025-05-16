import 'package:flutter/material.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例数据
    final int dailyCalories = 1450;
    final int calorieGoal = 2000;
    final int caloriePercentage = ((dailyCalories / calorieGoal) * 100).round();

    final nutrients = [
      {"name": "蛋白质", "current": 65, "goal": 120, "unit": "g"},
      {"name": "碳水", "current": 180, "goal": 250, "unit": "g"},
      {"name": "脂肪", "current": 45, "goal": 65, "unit": "g"},
    ];

    final meals = [
      {"id": 1, "time": "早餐", "calories": 350, "name": "燕麦粥配水果"},
      {"id": 2, "time": "午餐", "calories": 650, "name": "鸡肉沙拉配全麦面包"},
      {"id": 3, "time": "加餐", "calories": 150, "name": "希腊酸奶配坚果"},
      {"id": 4, "time": "晚餐", "calories": 300, "name": "蒸鱼配蔬菜"},
    ];

    final Color progressGreen = const Color(0xFF15803D);
    final Color progressBg = const Color(0xFFD6D6D6);
    final Color navBg = Colors.white;
    final Color navBorder = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: navBorder),
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    "Nutritrack",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "今日营养摄入概览",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                child: Column(
                  children: [
                    // 卡路里汇总
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // 环形进度条
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: caloriePercentage / 100,
                                      strokeWidth: 8,
                                      backgroundColor: progressBg,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          progressGreen),
                                    ),
                                  ),
                                  Text(
                                    "$caloriePercentage%",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "今日卡路里",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "目标: $calorieGoal 卡路里",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "$dailyCalories",
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    "已摄入卡路里",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  Text(
                                    "剩余: ${calorieGoal - dailyCalories} 卡路里",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 营养素摄入
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "营养素摄入",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ...nutrients.map((nutrient) {
                              final percent = (nutrient["current"] as int) /
                                  (nutrient["goal"] as int) *
                                  100;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(nutrient["name"] as String,
                                            style:
                                                const TextStyle(fontSize: 15)),
                                        Text(
                                          "${nutrient["current"]}/${nutrient["goal"]} ${nutrient["unit"]}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: percent / 100,
                                        minHeight: 8,
                                        backgroundColor: progressBg,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                progressGreen),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 今日餐食
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "今日餐食",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "点击查看详情",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...meals.map((meal) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(meal["time"] as String,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          meal["name"] as String,
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${meal["calories"]} 卡路里",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 底部导航栏
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: navBg,
                border: Border(top: BorderSide(color: navBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                      icon: Icons.home,
                      label: "首页",
                      selected: true,
                      onTap: () {}),
                  _NavItem(
                      icon: Icons.pie_chart,
                      label: "记录",
                      selected: false,
                      onTap: () {}),
                  _NavItem(
                      icon: Icons.message,
                      label: "建议",
                      selected: false,
                      onTap: () {}),
                  _NavItem(
                      icon: Icons.person,
                      label: "我的",
                      selected: false,
                      onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = const Color(0xFF4FC3F7);
    final Color unselectedColor = Colors.grey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: selected ? selectedColor : unselectedColor, size: 28),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? selectedColor : unselectedColor,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
