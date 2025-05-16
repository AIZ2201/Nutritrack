import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '个人中心',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5B6AF5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildGoalManagementCard(), // 新增目标管理卡片
            const SizedBox(height: 16),
            _buildHealthStatsCard(),
            const SizedBox(height: 16),
            _buildPreferencesCard(),
            const SizedBox(height: 16),
            _buildAccountCard(),
            const SizedBox(height: 80), // 为底部导航栏留出空间
          ],
        ),
      ),
    );
  }

  // 个人资料头部
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFF5B6AF5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF5B6AF5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '张小健',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '健康饮食爱好者',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF5B6AF5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF5B6AF5),
                ),
                SizedBox(width: 4),
                Text(
                  '编辑',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B6AF5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 目标管理卡片
  Widget _buildGoalManagementCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: const Color(0xFF5B6AF5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '我的目标',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B6AF5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: Color(0xFF5B6AF5),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '修改',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5B6AF5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 当前目标
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF5B6AF5).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF5B6AF5).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B6AF5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFF5B6AF5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '增肌塑形',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF5B6AF5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '每日蛋白质目标: 120g | 碳水目标: 250g | 脂肪目标: 60g',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 目标选项
            Row(
              children: [
                _buildGoalOption('减脂', Icons.trending_down, false),
                const SizedBox(width: 8),
                _buildGoalOption('增肌', Icons.fitness_center, true),
                const SizedBox(width: 8),
                _buildGoalOption('保持', Icons.balance, false),
                const SizedBox(width: 8),
                _buildGoalOption('健康', Icons.favorite, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 目标选项
  Widget _buildGoalOption(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF5B6AF5).withOpacity(0.1) 
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF5B6AF5) 
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF5B6AF5) 
                  : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? const Color(0xFF5B6AF5) 
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 健康数据卡片
  Widget _buildHealthStatsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  '我的健康数据',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHealthItem('身高', '175cm'),
                ),
                Expanded(
                  child: _buildHealthItem('体重', '68kg'),
                ),
                Expanded(
                  child: _buildHealthItem('BMI', '22.2'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildHealthItem('目标体重', '65kg'),
                ),
                Expanded(
                  child: _buildHealthItem('每日目标', '2000kcal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 健康数据项
  Widget _buildHealthItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
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

  // 偏好设置卡片
  Widget _buildPreferencesCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '饮食偏好',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPreferenceItem(Icons.no_meals, '饮食禁忌', '海鲜、花生'),
            const Divider(height: 24),
            _buildPreferenceItem(Icons.favorite_border, '饮食偏好', '低碳水、高蛋白'),
          ],
        ),
      ),
    );
  }

  // 偏好设置项
  Widget _buildPreferenceItem(IconData icon, String title, String description) {
    return Row(
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
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
      ],
    );
  }

  // 账户卡片
  Widget _buildAccountCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: const Color(0xFF5B6AF5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '账户设置',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAccountItem(Icons.person_outline, '个人资料'),
            const Divider(height: 24),
            _buildAccountItem(Icons.help_outline, '帮助与反馈'),
            const Divider(height: 24),
            _buildAccountItem(Icons.logout, '退出登录', isLogout: true),
          ],
        ),
      ),
    );
  }

  // 账户设置项
  Widget _buildAccountItem(IconData icon, String title, {bool isLogout = false}) {
    return Row(
      children: [
        Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF5B6AF5),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isLogout ? Colors.red : null,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: isLogout ? Colors.red.withOpacity(0.5) : Colors.grey,
          size: 16,
        ),
      ],
    );
  }
}