import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/profile_screen.dart';

void main() {
  testWidgets('个人中心页面UI渲染', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('个人中心'), findsOneWidget);
    expect(find.text('我的目标'), findsOneWidget);
    expect(find.text('我的健康数据'), findsOneWidget);
    expect(find.text('饮食偏好'), findsWidgets); // 修改这里
    expect(find.text('账户设置'), findsOneWidget);
    expect(find.text('退出登录'), findsOneWidget);
  });
}
