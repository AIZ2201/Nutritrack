import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/register_info_disease_screen.dart';

void main() {
  testWidgets('疾病信息补全页UI与交互', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoDiseaseScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
        goal: '控制疾病',
      ),
    ));
    expect(find.text('请问您目前的疾病类型是什么？'), findsOneWidget);

    await tester.tap(find.text('下一步'));
    await tester.pump();
    expect(find.text('请填写疾病类型'), findsOneWidget);

    await tester.enterText(
      find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == '填写疾病类型'),
      '高血压',
    );
    await tester.enterText(
      find.byWidgetPredicate((w) =>
          w is TextField && w.decoration?.hintText == '是：填写食物类别，否则不需要填写食物'),
      '花生',
    );
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
  });

  testWidgets('返回按钮', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegisterInfoDiseaseScreen(
        username: 'testuser',
        name: '张三',
        gender: '男',
        birth_date: '2023-01-01',
        region: '北京',
        goal: '控制疾病',
      ),
    ));
    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
  });
}
