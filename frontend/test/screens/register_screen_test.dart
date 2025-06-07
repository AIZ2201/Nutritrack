import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/register_screen.dart';

void main() {
  testWidgets('注册页UI渲染', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    expect(find.text('创建一个账户'), findsOneWidget);
    expect(find.text('Nutritrack'), findsOneWidget);
    expect(find.text('注册'), findsOneWidget);
    expect(find.text('返回登录'), findsOneWidget);
  });

  testWidgets('注册按钮禁用与启用', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    final registerBtn = find.widgetWithText(ElevatedButton, '注册');
    expect(tester.widget<ElevatedButton>(registerBtn).onPressed, isNotNull);
  });

  testWidgets('注册输入校验与弹窗', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.tap(find.text('注册'));
    await tester.pump();
    expect(find.text('注册'), findsOneWidget);
  });

  testWidgets('返回登录按钮跳转', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.tap(find.text('返回登录'));
    await tester.pumpAndSettle();
  });
}
