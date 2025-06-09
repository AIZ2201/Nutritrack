import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';
import 'dart:convert';

class DietRecordScreen extends StatefulWidget {
  final ApiService? apiService; // 新增
  const DietRecordScreen({Key? key, this.apiService}) : super(key: key);

  @override
  State<DietRecordScreen> createState() => _DietRecordScreenState();
}

class _DietRecordScreenState extends State<DietRecordScreen> {
  DateTime _currentDate = DateTime.now();
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _fetchDataForDate(_currentDate);
  }

  Future<Map<String, dynamic>> _fetchDataForDate(DateTime date) {
    final username = UserManager.instance.username;
   final dateStr =
    "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    // 修改为调用新的API
    return ApiService().fetchDietRecord(username: username ?? '', date: dateStr);
  }

  void _goToPreviousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
      _futureData = _fetchDataForDate(_currentDate);
    });
  }

  void _goToNextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _futureData = _fetchDataForDate(_currentDate);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  List<DateTime> _getWeekDays() {
    final List<DateTime> days = [];
    final DateTime startDay = _currentDate.subtract(const Duration(days: 3));
    for (int i = 0; i < 6; i++) {
      days.add(startDay.add(Duration(days: i)));
    }
    return days;
  }

  String _getChineseWeekday(int weekday) {
    const List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendarSection(),
            const SizedBox(height: 16),
            _buildDateNavigation(),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('加载失败: ${snapshot.error}'));
                }
                final data = snapshot.data ?? {};
                return Column(
                  children: [
                    _buildTodayIntakeSection(data),
                    const SizedBox(height: 16),
                    _buildMealSection(data),
                    const SizedBox(height: 80),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    final List<DateTime> weekDays = _getWeekDays();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(weekDays.length, (index) {
            final DateTime day = weekDays[index];
            final bool isSelected = day.year == _currentDate.year &&
                day.month == _currentDate.month &&
                day.day == _currentDate.day;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentDate = day;
                  _futureData = _fetchDataForDate(_currentDate);
                });
              },
              child: Column(
                children: [
                  Text(
                    _getChineseWeekday(day.weekday),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF5B6AF5)
                          : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5B6AF5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5B6AF5)
                            : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDateNavigation() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _goToPreviousDay,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF5B6AF5).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chevron_left,
                        color: const Color(0xFF5B6AF5), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '前一天',
                      style: TextStyle(
                        color: const Color(0xFF5B6AF5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              _formatDate(_currentDate),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            GestureDetector(
              onTap: _goToNextDay,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF5B6AF5).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '后一天',
                      style: TextStyle(
                        color: const Color(0xFF5B6AF5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        color: const Color(0xFF5B6AF5), size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayIntakeSection(Map<String, dynamic> data) {
    final nutrition = data['nutrition'] ?? {};
    final progress = data['progress'] ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
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
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutritionItem(
                    '卡路里', nutrition['calories']?.toString() ?? '0', ''),
                _buildNutritionItem(
                    '蛋白质', nutrition['protein']?.toString() ?? '0', 'g'),
                _buildNutritionItem(
                    '脂肪', nutrition['fat']?.toString() ?? '0', 'g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xFF5B6AF5),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(Map<String, dynamic> data) {
    // 新增：兼容后端 todayMeals 为字符串的情况
    Map<String, dynamic> meals = {};
    if (data.containsKey('meals')) {
      // 兼容老结构
      meals = data['meals'] as Map<String, dynamic>? ?? {};
    } else if (data.containsKey('todayMeals')) {
      dynamic todayMeals = data['todayMeals'];
      if (todayMeals is String) {
        try {
          todayMeals = jsonDecode(todayMeals.replaceAll("'", '"')); // 单引号转双引号
        } catch (e) {
          todayMeals = {};
        }
      }
      if (todayMeals is Map && todayMeals.containsKey('meals')) {
        meals = todayMeals['meals'] as Map<String, dynamic>? ?? {};
      }
    }
    print('meals: $meals');
    if (meals.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.no_meals,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                '该日期暂无饮食记录',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 对meals按meal_time字段排序
    final sortedMealEntries = meals.entries.toList()
      ..sort((a, b) {
        final timeA = a.value['meal_time'] ?? '';
        final timeB = b.value['meal_time'] ?? '';
        return timeA.compareTo(timeB);
      });

    return Column(
      children: sortedMealEntries.map((entry) {
        final mealType = entry.key;
        final mealData = entry.value;
        // foods 直接是 List<dynamic>
        final foodsRaw = mealData['foods'] as List<dynamic>? ?? [];
        // 转换 foods 为 List<Map<String, dynamic>>
        final foods = foodsRaw.map<Map<String, dynamic>>((f) => Map<String, dynamic>.from(f)).toList();
        // 计算总卡路里
        final totalCalories = foods.fold<num>(0, (sum, food) {
          final nutrition = food['nutrition'] as Map<String, dynamic>? ?? {};
          return sum + (nutrition['calories'] ?? 0);
        });
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildMealCard(
            mealType,
            mealData['meal_time'] ?? '',
            totalCalories.toString(),
            mealData['icon'],
            foods,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMealCard(String mealType, String time, String totalCalories,
      dynamic icon, List<Map<String, dynamic>> foods) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fastfood, // 统一用fastfood图标，后端不返回icon
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$mealType · $time',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B6AF5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF5B6AF5).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    totalCalories,
                    style: const TextStyle(
                      color: Color(0xFF5B6AF5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...foods.map((food) => _buildFoodItem(food)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food) {
    // 兼容 imageBase64、image_base64、base64 以及 image['base64'] 字段
    Widget imageWidget;
    String? imageBase64 = food['imageBase64'] ?? food['image_base64'] ?? food['base64'];
    // 适配 image 字段
    if (imageBase64 == null && food['image'] != null && food['image'] is Map && food['image']['base64'] != null) {
      imageBase64 = food['image']['base64'];
    }
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      final regex = RegExp(r'data:image/[^;]+;base64,');
      String pureBase64 = imageBase64.replaceAll(regex, '');
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
      imageWidget = const Icon(
        Icons.fastfood,
        color: Color(0xFF5B6AF5),
        size: 24,
      );
    }

    // 适配 foodName 字段和 nutrition
    final nutrition = food['nutrition'] as Map<String, dynamic>? ?? {};
    final calories = nutrition['calories']?.toString() ?? '';
    final protein = nutrition['protein']?.toString() ?? '';
    final fat = nutrition['fat']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: imageWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      food['foodName']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      calories,
                      style: const TextStyle(
                        color: Color(0xFF5B6AF5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '蛋白质: $protein g, 脂肪: $fat g',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
