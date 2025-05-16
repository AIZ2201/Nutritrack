import 'package:flutter/material.dart';
import 'register_info_body_screen.dart';
import 'register_info_muscle_screen.dart';
import 'register_info_maintain_screen.dart';
import 'register_info_disease_screen.dart';

class RegisterInfoGoalScreen extends StatefulWidget {
  const RegisterInfoGoalScreen({super.key});

  @override
  State<RegisterInfoGoalScreen> createState() => _RegisterInfoGoalScreenState();
}

class _RegisterInfoGoalScreenState extends State<RegisterInfoGoalScreen> {
  int? _selectedIndex;

  final List<String> goals = [
    "减脂减重",
    "增肌",
    "维持体重",
    "改善消化",
    "控制疾病",
  ];

  void _onGoalTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 跳转逻辑
    if (goals[index] == "减脂减重") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterInfoBodyScreen()),
      );
    } else if (goals[index] == "增肌") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterInfoMuscleScreen()),
      );
    } else if (goals[index] == "维持体重") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterInfoMaintainScreen()),
      );
    } else if (goals[index] == "控制疾病") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterInfoDiseaseScreen()),
      );
    }
    // "改善消化" 不跳转
  }

  @override
  Widget build(BuildContext context) {
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
                        widthFactor: 0.75, // 3/4 进度
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
                    "谢谢！现在谈谈你的饮食目标，从以下几个点中选择最重要的那一个吧！",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 目标选项
                  ...List.generate(goals.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => _onGoalTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: buttonGray,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedIndex == index
                                  ? lightBlue
                                  : buttonGray,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16),
                          child: Text(
                            goals[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // 返回按钮
                  SizedBox(
                    height: 48,
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
