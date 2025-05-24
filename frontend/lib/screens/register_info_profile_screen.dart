import 'package:flutter/material.dart';
import 'register_info_goal_screen.dart';

class RegisterInfoProfileScreen extends StatefulWidget {
  final String username;
  final String name;
  const RegisterInfoProfileScreen(
      {super.key, required this.username, required this.name});

  @override
  State<RegisterInfoProfileScreen> createState() =>
      _RegisterInfoProfileScreenState();
}

class _RegisterInfoProfileScreenState extends State<RegisterInfoProfileScreen> {
  String? _gender;
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color lightGray = const Color(0xFFB0B0B0);
    final Color borderGray = const Color(0xFFE0E0E0);
    final Color lightBlue = const Color(0xFF4FC3F7);
    final Color buttonGray = const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "让我们更了解你，\n填写性别、出生年月和所在地区，\nNutritrack会为你提供量身定制的健康指导！",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 进度条
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: borderGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.5, // 2/4 进度
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "请选择您的性别",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 性别选择
                  Row(
                    children: [
                      Radio<String>(
                        value: "男",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        activeColor: lightBlue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "男",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "女",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        activeColor: lightBlue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "女",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "请输入出生年月",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 出生年月输入框
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderGray, width: 1),
                    ),
                    child: TextField(
                      controller: _birthController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "yyyy/mm/dd",
                        hintStyle: TextStyle(color: lightGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "您所在的地区为",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 地区输入框
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderGray, width: 1),
                    ),
                    child: TextField(
                      controller: _regionController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "请输入所在地区",
                        hintStyle: TextStyle(color: lightGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 按钮行
                  Row(
                    children: [
                      // 返回按钮
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "返回",
                            style: TextStyle(
                              color: lightBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 下一步按钮
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_gender == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请选择性别')),
                              );
                              return;
                            }
                            final birthDate = _birthController.text.trim();
                            final region = _regionController.text.trim();
                            if (birthDate.isEmpty || region.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请填写出生年月和地区')),
                              );
                              return;
                            }
                            final dateReg = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!dateReg.hasMatch(birthDate)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('出生日期格式应为yyyy-MM-dd')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterInfoGoalScreen(
                                  username: widget.username,
                                  name: widget.name,
                                  gender: _gender!,
                                  birth_date: birthDate,
                                  region: region,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "下一步",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
