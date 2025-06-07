import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/register_info_body_screen.dart';

void main() {
  testWidgets('减脂信息补全页UI与交互', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoBodyScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
        goal: '减脂减重',
      ),
    ));
    expect(find.text('请问您多高？'), findsOneWidget);

    // 保证“下一步”按钮可见再点击
    await tester.ensureVisible(find.text('下一步'));
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.text('请填写所有信息'), findsOneWidget);

    await tester.enterText(
      find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == '填写身高'),
      '170',
    );
    await tester.enterText(
      find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == '填写当前体重'),
      '60',
    );
    await tester.enterText(
      find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == '填写目标体重'),
      '55',
    );
    await tester.ensureVisible(find.text('下一步'));
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
  });

  testWidgets('返回按钮', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoBodyScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
        goal: '减脂减重',
      ),
    ));
    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
  });
}
