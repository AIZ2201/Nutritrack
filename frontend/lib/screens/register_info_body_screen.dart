import 'package:flutter/material.dart';

class RegisterInfoBodyScreen extends StatefulWidget {
  const RegisterInfoBodyScreen({super.key});

  @override
  State<RegisterInfoBodyScreen> createState() => _RegisterInfoBodyScreenState();
}

class _RegisterInfoBodyScreenState extends State<RegisterInfoBodyScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

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
                    "你的健康之路从这里开始\n填写饮食目标\n让我们一起设定专属计划",
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
                        widthFactor: 1.0, // 4/4 进度
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
                  // 身高
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 8),
                    child: Text(
                      "请问您多高？",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderGray, width: 1),
                    ),
                    child: TextField(
                      controller: _heightController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "填写身高",
                        hintStyle: TextStyle(color: lightGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 当前体重
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 8),
                    child: Text(
                      "请问您当前体重是多少？",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderGray, width: 1),
                    ),
                    child: TextField(
                      controller: _weightController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "填写当前体重",
                        hintStyle: TextStyle(color: lightGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 目标体重
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 8),
                    child: Text(
                      "请问您的目标体重是多少？",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderGray, width: 1),
                    ),
                    child: TextField(
                      controller: _targetWeightController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "填写目标体重",
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
                            // 下一步逻辑（可跳转到注册完成或其他页面）
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
