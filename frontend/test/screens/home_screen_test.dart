import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders and login button exists',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // 检查 Nutritrack 标题
    expect(find.text('Nutritrack'), findsOneWidget);

    // 检查账号输入框
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == '账号'),
        findsOneWidget);

    // 检查密码输入框
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == '密码'),
        findsOneWidget);

    // 检查登录按钮
    expect(find.text('登录'), findsOneWidget);

    // 检查注册按钮
    expect(find.text('没有账号？注册一个'), findsOneWidget);

    // 点击登录按钮
    await tester.tap(find.text('登录'));
    await tester.pump();
    // 这里只能验证按钮可点击，具体跳转和API需集成测试
  });
}
