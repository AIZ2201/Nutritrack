import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/add_food_screen.dart';

void main() {
  testWidgets('添加食物页UI与输入校验', (tester) async {
    // 增大测试窗口，防止按钮被遮挡
    tester.binding.window.physicalSizeTestValue = const Size(800, 1600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(const MaterialApp(home: AddFoodScreen()));

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.tap(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.pumpAndSettle();
    expect(find.text('食物名称'), findsOneWidget);

    await tester.enterText(
        find.byWidgetPredicate(
            (w) => w is TextField && w.decoration?.hintText == '请输入食物名称'),
        '苹果');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.tap(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.pumpAndSettle();
    expect(find.text('餐食类型'), findsOneWidget);

    await tester.tap(find.text('早餐'));
    await tester.pump();

    // 填写四个营养成分输入框
    await tester.enterText(
        find
            .byWidgetPredicate(
                (w) => w is TextField && w.decoration?.hintText == '0')
            .at(0),
        '100'); // 热量
    await tester.enterText(
        find
            .byWidgetPredicate(
                (w) => w is TextField && w.decoration?.hintText == '0')
            .at(1),
        '10'); // 蛋白质
    await tester.enterText(
        find
            .byWidgetPredicate(
                (w) => w is TextField && w.decoration?.hintText == '0')
            .at(2),
        '20'); // 碳水
    await tester.enterText(
        find
            .byWidgetPredicate(
                (w) => w is TextField && w.decoration?.hintText == '0')
            .at(3),
        '5'); // 脂肪

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.tap(find.widgetWithText(ElevatedButton, '添加食物'));
    await tester.pumpAndSettle();
  });

  testWidgets('输入模式切换', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddFoodScreen()));
    await tester.tap(find.text('手动输入'));
    await tester.pump();
    expect(find.text('手动输入'), findsOneWidget);
    await tester.tap(find.text('拍照识别'));
    await tester.pump();
    expect(find.text('拍照识别'), findsOneWidget);
  });
}
