import 'dart:convert';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_food_screen.dart';
import '../services/api_service.dart';
import 'analysis_screen.dart'; // 新增
import '../services/user_manager.dart'; // 新增导入
import 'diet_record_screen.dart'; // 新增导入

// 固定建议内容结构
class _AdviceInfo {
  final IconData icon;
  final String title;
  final String desc;
  _AdviceInfo(this.icon, this.title, this.desc);
}

// 判断营养素是否充足，返回建议内容
_AdviceInfo _getAdvice({
  required IconData icon,
  required String label,
  required dynamic value,
  required dynamic target,
  required String increaseText,
  required String decreaseText,
  required String increaseDesc,
  required String decreaseDesc,
}) {
  double v = (value is num)
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '') ?? 0;
  double t = (target is num)
      ? target.toDouble()
      : double.tryParse(target?.toString() ?? '') ?? 0;
  if (t == 0) return _AdviceInfo(icon, '$label目标未设置', '暂无建议');
  if (v < t) {
    return _AdviceInfo(icon, increaseText, increaseDesc);
  } else {
    return _AdviceInfo(icon, decreaseText, decreaseDesc);
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // 页面列表
  late List<Widget> _pages; // 移除final，便于刷新

  @override
  void initState() {
    super.initState();
    _initPages();
  }

  void _initPages() {
    _pages = [
      _buildHomeContent(),
      const DietRecordScreen(), // 替换为新页面
      const AnalysisScreen(), // 替换分析页面
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? AppBar(
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
            )
          : null,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                // 导航到添加食物页面，并监听返回值
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFoodScreen()),
                );
                // 关键：添加后返回true时刷新
                if (result == true) {
                  setState(() {
                    _initPages(); // 重新生成页面，确保FutureBuilder刷新
                  });
                }
              },
              backgroundColor: const Color(0xFF5B6AF5),
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDateDisplay(), // 只显示日期
          const SizedBox(height: 8),
          _buildNutritionSummaryCard(),
          const SizedBox(height: 16),
          _buildHealthStatusCard(),
          const SizedBox(height: 16),
          _buildNutritionAdviceCard(),
          const SizedBox(height: 16),
          _buildFoodListCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 只显示当前日期的UI
  Widget _buildDateDisplay() {
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          dateStr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 今日营养摄入卡片
  Widget _buildNutritionSummaryCard() {
    final username = UserManager.instance.username;
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService().fetchMealsByDate(dateStr),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('加载失败'));
            }
            // 解析后端 todayMeals 字段
            final todayMeals = snapshot.data!['todayMeals'];
            Map<String, dynamic> meals = {};
            if (todayMeals != null && todayMeals['meals'] != null) {
              meals = todayMeals['meals'];
            }
            num totalCalories = 0,
                totalProtein = 0,
                totalFat = 0,
                totalCarbon = 0;
            if (meals.isNotEmpty) {
              for (var meal in meals.values) {
                if (meal != null &&
                    meal['foods'] != null &&
                    meal['foods'] is List) {
                  for (var food in meal['foods']) {
                    final nutrition = food['nutrition'] ?? {};
                    totalCalories += (nutrition['calories'] ?? 0) is num
                        ? nutrition['calories'] ?? 0
                        : num.tryParse(
                                nutrition['calories']?.toString() ?? '0') ??
                            0;
                    totalProtein += (nutrition['protein'] ?? 0) is num
                        ? nutrition['protein'] ?? 0
                        : num.tryParse(
                                nutrition['protein']?.toString() ?? '0') ??
                            0;
                    totalFat += (nutrition['fat'] ?? 0) is num
                        ? nutrition['fat'] ?? 0
                        : num.tryParse(nutrition['fat']?.toString() ?? '0') ??
                            0;
                    totalCarbon += (nutrition['carbon'] ?? 0) is num
                        ? nutrition['carbon'] ?? 0
                        : num.tryParse(
                                nutrition['carbon']?.toString() ?? '0') ??
                            0;
                  }
                }
              }
            }
            return Column(
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
                    _buildNutritionItem(
                        '${totalCalories.toStringAsFixed(0)}', '卡路里'),
                    _buildNutritionItem(
                        '${totalProtein.toStringAsFixed(0)}g', '蛋白质'),
                    _buildNutritionItem(
                        '${totalFat.toStringAsFixed(0)}g', '脂肪'),
                    _buildNutritionItem(
                        '${totalCarbon.toStringAsFixed(0)}g', '碳水'),
                  ],
                ),
              ],
            );
          },
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService().fetchAnalysisData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('加载失败'));
            }
            final data = snapshot.data!;
            // 兼容后端返回的 analysis 格式
            final analysis = data['analysis'] ?? {};
            final List<_AdviceInfo> advices = [];

            advices.add(_getAdviceFromAnalysis(
              icon: Icons.local_fire_department,
              label: '卡路里',
              analysis: analysis['calories'],
              increaseText: '建议增加卡路里摄入',
              decreaseText: '建议减少卡路里摄入',
              increaseDesc: '您的卡路里摄入低于目标，建议适当增加主食、坚果等高能量食物。',
              decreaseDesc: '您的卡路里摄入已超标，建议减少高热量食物的摄入。',
            ));
            advices.add(_getAdviceFromAnalysis(
              icon: Icons.fitness_center,
              label: '蛋白质',
              analysis: analysis['protein'],
              increaseText: '建议增加蛋白质摄入',
              decreaseText: '建议减少蛋白质摄入',
              increaseDesc: '您的蛋白质摄入低于目标，建议增加鸡胸肉、鱼类或豆制品的摄入。',
              decreaseDesc: '您的蛋白质摄入已超标，建议减少高蛋白食物的摄入。',
            ));
            advices.add(_getAdviceFromAnalysis(
              icon: Icons.opacity,
              label: '脂肪',
              analysis: analysis['fat'],
              increaseText: '建议增加脂肪摄入',
              decreaseText: '建议减少脂肪摄入',
              increaseDesc: '您的脂肪摄入低于目标，建议适当增加坚果、橄榄油等健康脂肪。',
              decreaseDesc: '您的脂肪摄入已超标，建议减少油炸食品和高脂肪食物。',
            ));
            advices.add(_getAdviceFromAnalysis(
              icon: Icons.grain,
              label: '碳水',
              analysis: analysis['carbon'],
              increaseText: '建议增加碳水摄入',
              decreaseText: '建议减少碳水摄入',
              increaseDesc: '您的碳水摄入低于目标，建议适当增加全谷物、薯类等主食。',
              decreaseDesc: '您的碳水摄入已超标，建议减少精制糖和高碳水食物。',
            ));

            return Column(
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
                ...advices
                    .map((a) => _buildAdviceItem(a.icon, a.title, a.desc))
                    .toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  // 根据 analysis 字段生成建议
  _AdviceInfo _getAdviceFromAnalysis({
    required IconData icon,
    required String label,
    required dynamic analysis,
    required String increaseText,
    required String decreaseText,
    required String increaseDesc,
    required String decreaseDesc,
  }) {
    if (analysis == null) {
      return _AdviceInfo(icon, '$label目标未设置', '暂无建议');
    }
    final status = analysis['状态']?.toString() ?? '';
    // 判断状态字符串是否包含“摄入不足”
    if (status.contains('摄入不足')) {
      return _AdviceInfo(icon, increaseText, increaseDesc);
    } else if (status.contains('超标') || status.contains('摄入过多')) {
      return _AdviceInfo(icon, decreaseText, decreaseDesc);
    } else {
      // 其它情况直接显示状态
      return _AdviceInfo(icon, '$label已达标', status.isNotEmpty ? status : '已达标');
    }
  }

  // 营养建议项目
  Widget _buildAdviceItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5B6AF5), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 食物列表卡片
  Widget _buildFoodListCard() {
    final username = UserManager.instance.username;
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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
                  '已添加食物',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: ApiService().fetchMealsByDate(dateStr),
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
                List<FoodItem> foodItems = [];
                for (var mealKey in meals.keys) {
                  final meal = meals[mealKey];
                  if (meal != null &&
                      meal['foods'] != null &&
                      meal['foods'] is List) {
                    for (var food in meal['foods']) {
                      // mealKey 作为类型传递给 FoodItem
                      foodItems.add(FoodItem.fromFastApi(food, mealKey));
                    }
                  }
                }
                if (foodItems.isEmpty) {
                  return const Center(child: Text('暂无食物记录'));
                }
                // 按添加顺序逆序显示，最新的在最上面
                foodItems = foodItems.reversed.toList();
                return Column(
                  children: [
                    for (int i = 0; i < foodItems.length; i++) ...[
                      _buildFoodItem(
                        foodItems[i].name,
                        foodItems[i].nutrition,
                        foodItems[i].calories,
                        foodItems[i].imageBase64,
                        foodItems[i].mealType, // 展示类型
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
  Widget _buildFoodItem(String name, String nutrition, String calories,
      [String? imageBase64, String? mealType]) {
    Widget imageWidget;
    String? pureBase64 = imageBase64;
    if (pureBase64 != null && pureBase64.isNotEmpty) {
      final regex = RegExp(r'data:image/[^;]+;base64,');
      pureBase64 = pureBase64.replaceAll(regex, '');
      try {
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(pureBase64),
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) =>
                const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      } catch (e) {
        imageWidget = const Icon(Icons.broken_image, color: Colors.grey);
      }
    } else {
      imageWidget = const Icon(Icons.image, color: Colors.grey);
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageWidget,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (mealType != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B6AF5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        mealType,
                        style: const TextStyle(
                          color: Color(0xFF5B6AF5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ]
                ],
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

// 修改FoodItem，增加mealType字段
class FoodItem {
  final String name;
  final String nutrition;
  final String calories;
  final String? imageBase64;
  final String? mealType; // 新增

  FoodItem({
    required this.name,
    required this.nutrition,
    required this.calories,
    this.imageBase64,
    this.mealType,
  });

  // mealTypeKey为早餐/午餐/晚餐/加餐的英文key
  factory FoodItem.fromFastApi(Map<String, dynamic> json,
      [String? mealTypeKey]) {
    final nutritionMap = json['nutrition'] ?? {};
    String nutritionStr =
        '蛋白质: ${nutritionMap['protein'] ?? 0}g | 碳水: ${nutritionMap['carbon'] ?? 0}g | 脂肪: ${nutritionMap['fat'] ?? 0}g';
    String caloriesStr = '${nutritionMap['calories'] ?? 0} kcal';
    String? imageBase64 = json['image_base64'];
    if (imageBase64 == null &&
        json['image'] != null &&
        json['image']['base64'] != null) {
      imageBase64 = json['image']['base64'];
    }
    if (imageBase64 != null && imageBase64.isEmpty) {
      imageBase64 = null;
    }
    // mealTypeKey转带餐字
    String? mealType;
    switch (mealTypeKey) {
      case '早':
        mealType = '早餐';
        break;
      case '中':
        mealType = '午餐';
        break;
      case '晚':
        mealType = '晚餐';
        break;
      case '加':
        mealType = '加餐';
        break;
      default:
        mealType = mealTypeKey;
    }
    return FoodItem(
      name: json['foodName'] ?? '',
      nutrition: nutritionStr,
      calories: caloriesStr,
      imageBase64: imageBase64,
      mealType: mealType,
    );
  }
}
