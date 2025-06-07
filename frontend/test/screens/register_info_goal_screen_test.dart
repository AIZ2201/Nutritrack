import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/register_info_goal_screen.dart';

void main() {
  testWidgets('目标选择页UI与交互', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoGoalScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
      ),
    ));
    expect(find.text('谢谢！现在谈谈你的饮食目标，从以下几个点中选择最重要的那一个吧！'), findsOneWidget);

    await tester.tap(find.text('减脂减重'));
    await tester.pumpAndSettle();
  });

  testWidgets('返回按钮', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoGoalScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
      ),
    ));
    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
  });
}
