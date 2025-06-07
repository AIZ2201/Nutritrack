import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/analysis_screen.dart';

void main() {
  testWidgets('分析页UI渲染', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AnalysisScreen()));
    expect(find.text('健康分析'), findsOneWidget);
    expect(find.text('营养洞察'), findsOneWidget);
    expect(find.text('营养顾问'), findsOneWidget);
  });

  testWidgets('顾问输入框交互', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AnalysisScreen()));
    await tester.enterText(find.byType(TextField).last, '蛋白质摄入多少合适');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
  });
}
