import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/register_info_name_screen.dart';

void main() {
  testWidgets('姓名输入页UI与交互', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoNameScreen(username: 'testuser'),
    ));
    expect(find.text('输入你的名字'), findsOneWidget);

    await tester.tap(find.text('下一步'));
    await tester.pump();
    expect(find.text('请输入姓名'), findsOneWidget);

    await tester.enterText(
      find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == '姓名'),
      '张三',
    );
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
  });

  testWidgets('返回按钮', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoNameScreen(username: 'testuser'),
    ));
    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
  });
}
