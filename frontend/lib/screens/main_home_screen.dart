import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_food_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // 页面列表
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),
      const Center(child: Text('饮食页面')), // 占位
      const Center(child: Text('分析页面')), // 占位
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3 ? AppBar(
        title: const Text(
          '健康饮食管理',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5B6AF5),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ) : null,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () {
          // 导航到添加食物页面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFoodScreen()),
          );
        },
        backgroundColor: const Color(0xFF5B6AF5),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF5B6AF5),
            unselectedItemColor: const Color(0xFF9CA3AF),
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined),
                activeIcon: Icon(Icons.restaurant_menu),
                label: '饮食',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                activeIcon: Icon(Icons.show_chart),
                label: '分析',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 主页内容 (保持原有代码)
  Widget _buildHomeContent() {
    // 保持原有的主页内容代码...
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildNutritionSummaryCard(),
          const SizedBox(height: 16),
          _buildHealthStatusCard(),
          const SizedBox(height: 16),
          _buildNutritionAdviceCard(),
          const SizedBox(height: 16),
          _buildFoodListCard(),
          const SizedBox(height: 80), // 为底部导航栏留出空间
        ],
      ),
    );
  }

  // 以下保留原有的所有卡片构建方法...
  // _buildNutritionSummaryCard()
  // _buildNutritionItem()
  // _buildHealthStatusCard()
  // _buildStatusItem()
  // _buildNutritionAdviceCard()
  // _buildAdviceItem()
  // _buildFoodListCard()
  // _buildFoodItem()

  // 今日营养摄入卡片
  Widget _buildNutritionSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '今日营养摄入',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionItem('1,450', '卡路里'),
                _buildNutritionItem('65g', '蛋白质'),
                _buildNutritionItem('45g', '脂肪'),
                _buildNutritionItem('180g', '碳水'),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.65,
                backgroundColor: const Color(0xFFE5E7EB),
                color: const Color(0xFF5B6AF5),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 营养项目
  Widget _buildNutritionItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5B6AF5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 健康状态卡片
  Widget _buildHealthStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '健康状态',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem('67', '健康指数'),
                ),
                Expanded(
                  child: _buildStatusItem('8.2', '睡眠质量'),
                ),
                Expanded(
                  child: _buildStatusItem('85%', '目标达成'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 状态项目
  Widget _buildStatusItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B6AF5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // 营养建议卡片
  Widget _buildNutritionAdviceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '今日营养建议',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAdviceItem(
              Icons.fitness_center,
              '增加蛋白质摄入',
              '您今天的蛋白质摄入低于目标，建议增加鸡胸肉、鱼类或豆制品的摄入。',
            ),
            const Divider(height: 24),
            _buildAdviceItem(
              Icons.grain,
              '减少碳水化合物',
              '您的碳水摄入已接近每日上限，建议晚餐选择低碳水食物。',
            ),
            const Divider(height: 24),
            _buildAdviceItem(
              Icons.refresh,
              '补充维生素C',
              '建议增加柑橘类水果或绿叶蔬菜的摄入，以满足维生素C的需求。',
            ),
          ],
        ),
      ),
    );
  }

  // 建议项目
  Widget _buildAdviceItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF5B6AF5),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 食物列表卡片
  Widget _buildFoodListCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '今日已添加食物',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFoodItem(
              '全麦面包配鸡蛋',
              '蛋白质: 15g | 碳水: 30g | 脂肪: 8g',
              '320 kcal',
            ),
            const Divider(height: 24),
            _buildFoodItem(
              '鸡胸肉沙拉',
              '蛋白质: 28g | 碳水: 15g | 脂肪: 12g',
              '280 kcal',
            ),
            const Divider(height: 24),
            _buildFoodItem(
              '希腊酸奶配蓝莓',
              '蛋白质: 12g | 碳水: 18g | 脂肪: 5g',
              '170 kcal',
            ),
          ],
        ),
      ),
    );
  }

  // 食物项目
  Widget _buildFoodItem(String name, String nutrition, String calories) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nutrition,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Text(
          calories,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF5B6AF5),
          ),
        ),
      ],
    );
  }
}