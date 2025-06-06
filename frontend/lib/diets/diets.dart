import 'package:flutter/material.dart';

class DietRecordPageV2 extends StatefulWidget {
  const DietRecordPageV2({super.key});

  @override
  State<DietRecordPageV2> createState() => _DietRecordPageV2State();
}

class _DietRecordPageV2State extends State<DietRecordPageV2> {
  DateTime _currentDate = DateTime(2025, 4, 24);

  // 存储不同日期的营养数据和食物记录
  Map<String, Map<String, dynamic>> _dailyData = {};

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // 初始化示例数据
    _dailyData = {
      '2025-04-22': {
        'nutrition': {'calories': '1180', 'protein': '72', 'fat': '98'},
        'progress': 0.55,
        'meals': {
          '早餐': {
            'time': '08:00',
            'totalCalories': '320',
            'icon': Icons.wb_sunny_outlined,
            'foods': [
              {
                'name': '牛奶麦片',
                'calories': '220 卡路里',
                'details': '蛋白质: 8g  脂肪: 5g  碳水: 35g'
              },
              {
                'name': '苹果',
                'calories': '100 卡路里',
                'details': '蛋白质: 0.5g  脂肪: 0.3g  碳水: 25g'
              },
            ]
          },
          '午餐': {
            'time': '12:00',
            'totalCalories': '480',
            'icon': Icons.restaurant_menu,
            'foods': [
              {
                'name': '红烧肉',
                'calories': '380 卡路里',
                'details': '蛋白质: 25g  脂肪: 28g  碳水: 8g'
              },
              {
                'name': '白米饭',
                'calories': '100 卡路里',
                'details': '蛋白质: 2g  脂肪: 0.5g  碳水: 22g'
              },
            ]
          },
          '晚餐': {
            'time': '18:00',
            'totalCalories': '380',
            'icon': Icons.dinner_dining,
            'foods': [
              {
                'name': '蒸蛋羹',
                'calories': '180 卡路里',
                'details': '蛋白质: 12g  脂肪: 8g  碳水: 5g'
              },
              {
                'name': '青菜汤',
                'calories': '200 卡路里',
                'details': '蛋白质: 3g  脂肪: 1g  碳水: 8g'
              },
            ]
          },
        }
      },
      '2025-04-23': {
        'nutrition': {'calories': '1420', 'protein': '95', 'fat': '118'},
        'progress': 0.72,
        'meals': {
          '早餐': {
            'time': '08:15',
            'totalCalories': '280',
            'icon': Icons.wb_sunny_outlined,
            'foods': [
              {
                'name': '豆浆',
                'calories': '120 卡路里',
                'details': '蛋白质: 6g  脂肪: 4g  碳水: 12g'
              },
              {
                'name': '包子',
                'calories': '160 卡路里',
                'details': '蛋白质: 5g  脂肪: 3g  碳水: 28g'
              },
            ]
          },
          '午餐': {
            'time': '12:20',
            'totalCalories': '520',
            'icon': Icons.restaurant_menu,
            'foods': [
              {
                'name': '宫保鸡丁',
                'calories': '420 卡路里',
                'details': '蛋白质: 32g  脂肪: 18g  碳水: 25g'
              },
              {
                'name': '紫米饭',
                'calories': '100 卡路里',
                'details': '蛋白质: 3g  脂肪: 1g  碳水: 20g'
              },
            ]
          },
          '晚餐': {
            'time': '19:00',
            'totalCalories': '620',
            'icon': Icons.dinner_dining,
            'foods': [
              {
                'name': '清蒸鱼',
                'calories': '320 卡路里',
                'details': '蛋白质: 28g  脂肪: 12g  碳水: 2g'
              },
              {
                'name': '蒜蓉西兰花',
                'calories': '180 卡路里',
                'details': '蛋白质: 8g  脂肪: 6g  碳水: 15g'
              },
              {
                'name': '小米粥',
                'calories': '120 卡路里',
                'details': '蛋白质: 3g  脂肪: 1g  碳水: 25g'
              },
            ]
          },
        }
      },
      '2025-04-24': {
        'nutrition': {'calories': '1335', 'protein': '86', 'fat': '134'},
        'progress': 0.65,
        'meals': {
          '早餐': {
            'time': '08:30',
            'totalCalories': '255',
            'icon': Icons.wb_sunny_outlined,
            'foods': [
              {
                'name': '燕麦粥',
                'calories': '150 卡路里',
                'details': '蛋白质: 5g  脂肪: 2.7g  碳水: 3g'
              },
              {
                'name': '香蕉',
                'calories': '105 卡路里',
                'details': '蛋白质: 1g  脂肪: 2.7g  碳水: 0g'
              },
            ]
          },
          '午餐': {
            'time': '12:30',
            'totalCalories': '430',
            'icon': Icons.restaurant_menu,
            'foods': [
              {
                'name': '鸡肉沙拉',
                'calories': '350 卡路里',
                'details': '蛋白质: 30g  脂肪: 10g  碳水: 15g'
              },
              {
                'name': '全麦面包',
                'calories': '80 卡路里',
                'details': '蛋白质: 4g  脂肪: 1.5g  碳水: 15g'
              },
            ]
          },
          '晚餐': {
            'time': '18:30',
            'totalCalories': '650',
            'icon': Icons.dinner_dining,
            'foods': [
              {
                'name': '番茄炒蛋',
                'calories': '280 卡路里',
                'details': '蛋白质: 15g  脂肪: 18g  碳水: 12g'
              },
              {
                'name': '黑米饭',
                'calories': '180 卡路里',
                'details': '蛋白质: 4g  脂肪: 2g  碳水: 35g'
              },
              {
                'name': '冬瓜汤',
                'calories': '190 卡路里',
                'details': '蛋白质: 8g  脂肪: 5g  碳水: 15g'
              },
            ]
          },
        }
      },
      '2025-04-25': {
        'nutrition': {'calories': '1580', 'protein': '102', 'fat': '145'},
        'progress': 0.78,
        'meals': {
          '早餐': {
            'time': '07:45',
            'totalCalories': '380',
            'icon': Icons.wb_sunny_outlined,
            'foods': [
              {
                'name': '煎蛋',
                'calories': '180 卡路里',
                'details': '蛋白质: 12g  脂肪: 14g  碳水: 2g'
              },
              {
                'name': '吐司',
                'calories': '120 卡路里',
                'details': '蛋白质: 4g  脂肪: 2g  碳水: 22g'
              },
              {
                'name': '牛奶',
                'calories': '80 卡路里',
                'details': '蛋白质: 4g  脂肪: 4g  碳水: 6g'
              },
            ]
          },
          '午餐': {
            'time': '12:45',
            'totalCalories': '680',
            'icon': Icons.restaurant_menu,
            'foods': [
              {
                'name': '红烧排骨',
                'calories': '480 卡路里',
                'details': '蛋白质: 35g  脂肪: 25g  碳水: 18g'
              },
              {
                'name': '炒青菜',
                'calories': '100 卡路里',
                'details': '蛋白质: 3g  脂肪: 5g  碳水: 8g'
              },
              {
                'name': '米饭',
                'calories': '100 卡路里',
                'details': '蛋白质: 2g  脂肪: 0.5g  碳水: 22g'
              },
            ]
          },
          '晚餐': {
            'time': '19:15',
            'totalCalories': '520',
            'icon': Icons.dinner_dining,
            'foods': [
              {
                'name': '麻婆豆腐',
                'calories': '320 卡路里',
                'details': '蛋白质: 18g  脂肪: 15g  碳水: 20g'
              },
              {
                'name': '紫菜蛋花汤',
                'calories': '200 卡路里',
                'details': '蛋白质: 12g  脂肪: 8g  碳水: 10g'
              },
            ]
          },
        }
      },
      '2025-04-26': {
        'nutrition': {'calories': '1250', 'protein': '78', 'fat': '105'},
        'progress': 0.58,
        'meals': {
          '早餐': {
            'time': '08:20',
            'totalCalories': '290',
            'icon': Icons.wb_sunny_outlined,
            'foods': [
              {
                'name': '酸奶',
                'calories': '150 卡路里',
                'details': '蛋白质: 8g  脂肪: 6g  碳水: 15g'
              },
              {
                'name': '坚果',
                'calories': '140 卡路里',
                'details': '蛋白质: 5g  脂肪: 12g  碳水: 4g'
              },
            ]
          },
          '午餐': {
            'time': '12:10',
            'totalCalories': '450',
            'icon': Icons.restaurant_menu,
            'foods': [
              {
                'name': '蒸蛋',
                'calories': '200 卡路里',
                'details': '蛋白质: 15g  脂肪: 12g  碳水: 3g'
              },
              {
                'name': '蔬菜沙拉',
                'calories': '150 卡路里',
                'details': '蛋白质: 5g  脂肪: 8g  碳水: 12g'
              },
              {
                'name': '全麦饼干',
                'calories': '100 卡路里',
                'details': '蛋白质: 3g  脂肪: 3g  碳水: 15g'
              },
            ]
          },
          '晚餐': {
            'time': '18:45',
            'totalCalories': '510',
            'icon': Icons.dinner_dining,
            'foods': [
              {
                'name': '白切鸡',
                'calories': '310 卡路里',
                'details': '蛋白质: 28g  脂肪: 15g  碳水: 2g'
              },
              {
                'name': '凉拌黄瓜',
                'calories': '80 卡路里',
                'details': '蛋白质: 2g  脂肪: 3g  碳水: 8g'
              },
              {
                'name': '小馄饨',
                'calories': '120 卡路里',
                'details': '蛋白质: 6g  脂肪: 4g  碳水: 15g'
              },
            ]
          },
        }
      },
    };
  }

  void _goToPreviousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> _getCurrentDayData() {
    String dateKey = _getDateKey(_currentDate);
    return _dailyData[dateKey] ?? {
      'nutrition': {'calories': '0', 'protein': '0', 'fat': '0'},
      'progress': 0.0,
      'meals': {}
    };
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
            _buildTodayIntakeSection(),
            const SizedBox(height: 16),
            _buildMealSection(),
            const SizedBox(height: 80),
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
                });
              },
              child: Column(
                children: [
                  Text(
                    _getChineseWeekday(day.weekday),
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF5B6AF5) : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5B6AF5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF5B6AF5) : Colors.grey[300]!,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    Icon(Icons.chevron_left, color: const Color(0xFF5B6AF5), size: 20),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    Icon(Icons.chevron_right, color: const Color(0xFF5B6AF5), size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayIntakeSection() {
    final currentData = _getCurrentDayData();
    final nutrition = currentData['nutrition'];
    final progress = currentData['progress'];

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
                _buildNutritionItem('卡路里', nutrition['calories'], ''),
                _buildNutritionItem('蛋白质', nutrition['protein'], 'g'),
                _buildNutritionItem('脂肪', nutrition['fat'], 'g'),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
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

  Widget _buildMealSection() {
    final currentData = _getCurrentDayData();
    final meals = currentData['meals'] as Map<String, dynamic>;

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

    return Column(
      children: meals.entries.map((entry) {
        final mealType = entry.key;
        final mealData = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildMealCard(
            mealType,
            mealData['time'],
            mealData['totalCalories'],
            mealData['icon'],
            List<Map<String, String>>.from(mealData['foods']),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMealCard(String mealType, String time, String totalCalories,
      IconData icon, List<Map<String, String>> foods) {
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
                  icon,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: const Color(0xFF5B6AF5).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: const Color(0xFF5B6AF5),
                    size: 18,
                  ),
                  label: Text(
                    '添加食物',
                    style: TextStyle(
                      color: const Color(0xFF5B6AF5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Map<String, String> food) {
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
            child: Icon(
              Icons.fastfood,
              color: const Color(0xFF5B6AF5),
              size: 24,
            ),
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
                      food['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      food['calories']!,
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
                  food['details']!,
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