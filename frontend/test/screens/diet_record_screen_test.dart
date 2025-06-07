import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/diet_record_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/user_manager.dart';

// 自定义一个FakeApiService，直接返回假数据
class FakeApiService extends ApiService {
  @override
  Future<Map<String, dynamic>> fetchDietRecord({
    required String username,
    required String date,
  }) async {
    return {
      "nutrition": {
        "calories": "123",
        "protein": "12",
        "fat": "4",
      },
      "meals": {
        "早餐": {
          "time": "07:30",
          "totalCalories": "123",
          "icon": "",
          "foods": [
            {
              "name": "鸡蛋",
              "calories": "80",
              "details": "1个",
              "imageBase64": null,
            }
          ]
        }
      },
    };
  }
}

void main() {
  setUp(() {
    UserManager.instance.username = 'testuser';
  });

  testWidgets('DietRecordScreen renders nutrition and meal sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DietRecordScreen(apiService: FakeApiService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('今日营养摄入'), findsOneWidget);
    expect(find.text('卡路里'), findsOneWidget);
    expect(find.text('蛋白质'), findsOneWidget);
    expect(find.text('脂肪'), findsOneWidget);
    expect(find.text('前一天'), findsOneWidget);
    expect(find.text('后一天'), findsOneWidget);

    expect(find.textContaining('早餐'), findsOneWidget);
    expect(find.textContaining('07:30'), findsOneWidget);
    expect(find.text('鸡蛋'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text('1个'), findsOneWidget);

    expect(find.textContaining('周'), findsWidgets);
  });
}
