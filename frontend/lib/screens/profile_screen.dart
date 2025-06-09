import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';
import './register_info_goal_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = _fetchProfile();
  }

  Future<Map<String, dynamic>?> _fetchProfile() async {
    final username = UserManager.instance.username;
    if (username == null) return null;
    try {
      final profile = await ApiService().fetchUserProfile(username);
      return profile;
    } catch (e) {
      return null;
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _futureProfile = _fetchProfile();
    });
  }

  // 修改昵称
  Future<void> _showEditNameDialog(Map<String, dynamic> profile) async {
    final controller =
        TextEditingController(text: profile['name']?.toString() ?? '');
    final username = profile['username']?.toString() ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改昵称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '新昵称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final resp =
          await ApiService().updateUserName(username: username, name: result);
      if (resp['success'] == true || resp['message'] == "昵称更新成功") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('昵称修改成功')));
        _refreshProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('修改失败: ${resp['message'] ?? ''}')));
      }
    }
  }

  // 修改目标
  Future<void> _showEditGoalDialog(Map<String, dynamic> profile) async {
    // 跳转到注册流程中的目标选择页面，复用 RegisterInfoGoalScreen
    final username = profile['username']?.toString() ?? '';
    final name = profile['name']?.toString() ?? '';
    final gender = profile['gender']?.toString() ?? '';
    final birthDate = profile['birth_date']?.toString() ?? '';
    final region = profile['region']?.toString() ?? '';

    // 导入RegisterInfoGoalScreen时需确保已import
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterInfoGoalScreen(
          username: username,
          name: name,
          gender: gender,
          birth_date: birthDate,
          region: region,
        ),
      ),
    );
    // 回来后刷新
    _refreshProfile();
  }

  // 修改健康信息（点击个人资料时弹窗）
  Future<void> _showEditHealthDialog(Map<String, dynamic> profile) async {
    final username = profile['username']?.toString() ?? '';
    final heightController =
        TextEditingController(text: profile['height']?.toString() ?? '');
    final weightController =
        TextEditingController(text: profile['weight']?.toString() ?? '');
    final birthDateController =
        TextEditingController(text: profile['birth_date']?.toString() ?? '');
    final regionController =
        TextEditingController(text: profile['region']?.toString() ?? '');

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改健康信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: '身高(cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: '体重(kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: birthDateController,
              decoration: const InputDecoration(labelText: '出生日期(YYYY-MM-DD)'),
            ),
            TextField(
              controller: regionController,
              decoration: const InputDecoration(labelText: '地区'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'height': heightController.text.trim(),
                'weight': weightController.text.trim(),
                'birth_date': birthDateController.text.trim(),
                'region': regionController.text.trim(),
              });
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      final resp = await ApiService().updateUserHealth(
        username: username,
        height: result['height'],
        weight: result['weight'],
        birthDate: result['birth_date'],
        region: result['region'],
      );
      if (resp['success'] == true || resp['message'] == "健康信息更新成功") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('健康信息修改成功')));
        _refreshProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('修改失败: ${resp['message'] ?? ''}')));
      }
    }
  }

  // 修改饮食偏好（只修改单个字段）
  Future<void> _showEditPreferenceSingleDialog(Map<String, dynamic> profile,
      String field, String label, String oldValue) async {
    final username = profile['username']?.toString() ?? '';
    final controller = TextEditingController(text: oldValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改$label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      Map<String, String?> update = {};
      if (field == 'disease') {
        update['disease'] = result;
      } else if (field == 'allergy') {
        update['allergy'] = result;
      }
      final resp = await ApiService().updateUserPreference(
        username: username,
        disease: update['disease'],
        allergy: update['allergy'],
      );
      if (resp['success'] == true || resp['message'] == "饮食偏好更新成功") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('饮食偏好修改成功')));
        _refreshProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('修改失败: ${resp['message'] ?? ''}')));
      }
    }
  }

  void _logout() {
    UserManager.instance.username = null;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('加载失败或用户不存在'));
          }
          final profile = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 16),
                _buildGoalManagementCard(profile),
                const SizedBox(height: 16),
                _buildHealthStatsCard(profile),
                const SizedBox(height: 16),
                _buildPreferencesCard(profile),
                const SizedBox(height: 16),
                _buildAccountCard(profile),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  // 个人资料头部
  Widget _buildProfileHeader(Map<String, dynamic> profile) {
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
                Text(
                  profile['name']?.toString() ?? profile['username'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile['goal']?.toString() ?? '健康饮食爱好者',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditNameDialog(profile),
            child: Container(
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
          ),
        ],
      ),
    );
  }

  // 目标管理卡片
  Widget _buildGoalManagementCard(Map<String, dynamic> profile) {
    final goal = profile['goal']?.toString() ?? '未设置';
    final targetWeight = profile['target_weight']?.toString() ?? '-';
    final targetMuscle = profile['target_muscle']?.toString() ?? '-';
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
                GestureDetector(
                  onTap: () => _showEditGoalDialog(profile),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        Text(
                          goal,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF5B6AF5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '目标体重: $targetWeight kg | 目标肌肉: $targetMuscle kg',
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
          ],
        ),
      ),
    );
  }

  // 健康数据卡片（只显示有的信息，不可编辑）
  Widget _buildHealthStatsCard(Map<String, dynamic> profile) {
    final List<Widget> items = [];
    if (profile['height'] != null && profile['height'].toString().isNotEmpty) {
      items.add(
          Expanded(child: _buildHealthItem('身高', '${profile['height']} cm')));
    }
    if (profile['weight'] != null && profile['weight'].toString().isNotEmpty) {
      items.add(
          Expanded(child: _buildHealthItem('体重', '${profile['weight']} kg')));
    }
    if (profile['birth_date'] != null &&
        profile['birth_date'].toString().isNotEmpty) {
      items.add(Expanded(
          child: _buildHealthItem('出生日期', profile['birth_date'].toString())));
    }
    if (profile['region'] != null && profile['region'].toString().isNotEmpty) {
      items.add(Expanded(
          child: _buildHealthItem('地区', profile['region'].toString())));
    }
    if (items.isEmpty) {
      items.add(const Expanded(
          child: Text('暂无健康数据', style: TextStyle(color: Colors.grey))));
    }
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
            Row(children: items),
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
  Widget _buildPreferencesCard(Map<String, dynamic> profile) {
    final disease = profile['disease']?.toString() ?? '无';
    final allergy = profile['allergy']?.toString() ?? '无';
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
            GestureDetector(
              onTap: () => _showEditPreferenceSingleDialog(
                  profile, 'disease', '疾病', disease),
              child: Row(
                children: [
                  _buildPreferenceItem(Icons.no_meals, '疾病', disease,
                      showArrow: true),
                ],
              ),
            ),
            const Divider(height: 24),
            GestureDetector(
              onTap: () => _showEditPreferenceSingleDialog(
                  profile, 'allergy', '过敏', allergy),
              child: Row(
                children: [
                  _buildPreferenceItem(Icons.favorite_border, '过敏', allergy,
                      showArrow: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 偏好设置项
  Widget _buildPreferenceItem(IconData icon, String title, String description,
      {bool showArrow = false}) {
    return Expanded(
      child: Row(
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
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
        ],
      ),
    );
  }

  // 账户卡片
  Widget _buildAccountCard(Map<String, dynamic> profile) {
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
            GestureDetector(
              onTap: () => _showEditHealthDialog(profile),
              child: _buildAccountItem(Icons.person_outline, '个人资料',
                  showArrow: true),
            ),
            const Divider(height: 24),
            GestureDetector(
              onTap: _logout,
              child: _buildAccountItem(Icons.logout, '退出登录', isLogout: true),
            ),
          ],
        ),
      ),
    );
  }

  // 账户设置项
  Widget _buildAccountItem(IconData icon, String title,
      {bool isLogout = false, bool showArrow = false}) {
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
        if (showArrow)
          Icon(
            Icons.arrow_forward_ios,
            color: isLogout ? Colors.red.withOpacity(0.5) : Colors.grey,
            size: 16,
          ),
      ],
    );
  }
}
