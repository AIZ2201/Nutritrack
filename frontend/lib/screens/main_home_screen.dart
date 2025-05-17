import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_food_screen.dart';
import '../services/api_service.dart';

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
    // 推荐做法：将用户名保存在全局状态、Provider、GetX、shared_preferences等
    // 这里举例用Provider（需在主入口用Provider包裹并传递用户信息）
    //
    // import 'package:provider/provider.dart';
    // class UserModel with ChangeNotifier { String username; ... }
    // 在主入口：ChangeNotifierProvider(create: (_) => UserModel(), child: MyApp())
    //
    // 然后这里获取：
    // final username = Provider.of<UserModel>(context, listen: false).username;
    //
    // 如果用shared_preferences：
    // final prefs = await SharedPreferences.getInstance();
    // final username = prefs.getString('username') ?? '';
    //
    // 如果用GetX：
    // final username = Get.find<UserController>().username;
    //
    // 临时写死：
    const username = "testuser";
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
            FutureBuilder<Map<String, dynamic>>(
              future: ApiService().fetchTodayMeals(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载失败: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('暂无食物记录'));
                }
                // 调试输出
                print('后端返回数据: ${snapshot.data}');
                final todayMeals = snapshot.data!['todayMeals'];
                if (todayMeals == null || todayMeals['meals'] == null) {
                  return const Center(child: Text('暂无食物记录'));
                }
                final meals = todayMeals['meals'];
                List<dynamic> foods = [];
                for (var mealKey in ['breakfast', 'lunch', 'dinner']) {
                  final meal = meals[mealKey];
                  if (meal != null && meal['foods'] != null && meal['foods'] is List) {
                    foods.addAll(meal['foods']);
                  }
                }
                // 再次调试 foods
                print('foods: $foods');
                if (foods.isEmpty) {
                  return const Center(child: Text('暂无食物记录'));
                }
                final foodItems = foods.map((item) => FoodItem.fromFastApi(item)).toList();
                return Column(
                  children: [
                    for (int i = 0; i < foodItems.length; i++) ...[
                      _buildFoodItem(
                        foodItems[i].name,
                        foodItems[i].nutrition,
                        foodItems[i].calories,
                      ),
                      if (i != foodItems.length - 1) const Divider(height: 24),
                    ]
                  ],
                );
              },
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

class FoodItem {
  final String name;
  final String nutrition;
  final String calories;

  FoodItem({required this.name, required this.nutrition, required this.calories});

  factory FoodItem.fromFastApi(Map<String, dynamic> json) {
    final nutritionMap = json['nutrition'] ?? {};
    String nutritionStr =
        '蛋白质: ${nutritionMap['protein'] ?? 0}g | 碳水: ${nutritionMap['carbon'] ?? 0}g | 脂肪: ${nutritionMap['fat'] ?? 0}g';
    String caloriesStr = '${nutritionMap['calories'] ?? 0} kcal';
    return FoodItem(
      name: json['foodName'] ?? '',
      nutrition: nutritionStr,
      calories: caloriesStr,
    );
  }
}