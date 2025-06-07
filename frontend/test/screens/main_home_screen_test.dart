import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_home_screen.dart';

void main() {
  testWidgets('主页面UI渲染', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainHomeScreen()));
    expect(find.text('健康饮食管理'), findsOneWidget);
    expect(find.text('今日营养摄入'), findsOneWidget);
    expect(find.text('健康状态'), findsOneWidget);
    expect(find.text('今日营养建议'), findsOneWidget);
    expect(find.text('已添加食物'), findsOneWidget);
  });

  testWidgets('底部导航切换', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainHomeScreen()));
    await tester.tap(find.text('饮食'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('分析'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('首页'));
    await tester.pumpAndSettle();
  });
}
