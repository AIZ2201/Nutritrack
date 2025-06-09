import 'dart:async';
import 'dart:convert'; // 添加此行以支持 JSON 解码
import 'package:http/http.dart' as http;
import 'user_manager.dart'; // 新增

enum BackendMode { local, remote, server } // 定义后端模式枚举

bool useMock = true; // 是否使用模拟数据

class ApiService {
  final BackendMode backendMode;

  // 修改默认模式为 remote
  ApiService({this.backendMode = BackendMode.remote}); // 后端模式（可切换）

  String _getBaseUrl() {
    switch (backendMode) {
      case BackendMode.local:
        return 'http://192.168.1.100:8000'; // 本地模式地址
      case BackendMode.remote:
        return 'http://10.208.100.52:8000'; // 异地模式地址
      case BackendMode.server:
        return 'http://123.60.149.85:8000'; // 服务器模式地址
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final baseUrl = _getBaseUrl(); // 根据模式获取后端地址
    final requestBody =
        json.encode({'username': username, 'password': password}); // 构建 JSON 数据
    print("发送请求到: $baseUrl/auth/login"); // 打印请求地址
    print("请求体: $requestBody"); // 打印 JSON 包

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'), // 动态拼接地址
      headers: {'Content-Type': 'application/json'}, // 设置请求头
      body: requestBody, // 发送 JSON 数据
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print("后端返回: $responseBody"); // 调试输出
      // 返回完整的响应数据，包括 message 和 role
      return {
        "success": responseBody['message'] == "login_successful",
        "role": responseBody['role']
      };
    } else if (response.statusCode == 401) {
      // 处理用户名或密码错误的情况
      print("登录失败: Invalid username or password");
      return {"success": false, "role": null};
    } else {
      throw Exception('登录失败: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _mockLogin(
      String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
    // 模拟用户名和密码验证
    if (username == "111" && password == "111") {
      return {"success": true, "role": "user"}; // 模拟返回角色信息
    } else {
      return {"success": false, "role": null};
    }
  }

  /// 获取指定日期的食物卡片内容
  Future<Map<String, dynamic>> fetchMealsByDate(String date) async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/homePage/todayMeals';
    final username = UserManager.instance.username;
    final requestBody = json.encode({'username': username, 'date': date});
    print('发送到后端的信息: $requestBody'); // 打印发送内容
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('获取食物数据失败: ${response.body}');
    }
  }

  /// 上传饮食记录（含图片 base64）
  Future<bool> uploadFoodRecord({
    required String foodName,
    required double protein,
    required double fat,
    required double carbon,
    required double calories,
    required String time,
    required String image_base64,
  }) async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/records/upload';
    final username = UserManager.instance.username ?? "";

    if (username.isEmpty) {
      print('上传失败：用户名为空');
      return false;
    }

    // 正确构建 JSON 请求体
    final body = json.encode({
      'username': username,
      'foodName': foodName,
      'protein': protein,
      'fat': fat,
      'carbon': carbon,
      'calories': calories,
      'time': time,
      'image_base64': image_base64,
    });

 

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('后端响应状态码: ${response.statusCode}');
    print('后端响应内容: ${response.body}');

    if (response.statusCode == 200) {
      print('上传成功');
      return true;
    } else {
      print('上传失败: ${response.body}');
      return false;
    }
  }

  /// 注册账号
  Future<Map<String, dynamic>> register(
      String username, String password) async {
    final baseUrl = _getBaseUrl();
    final requestBody = json.encode({
      'username': username,
      'password': password,
      'role': 'user', // 新增role字段，默认user
    });

    print("发送注册请求到: $baseUrl/register?step=1");
    print("请求体: $requestBody");

    final response = await http.post(
      Uri.parse('$baseUrl/register?step=1'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print("注册返回: $responseBody");
      return {"success": true, "message": responseBody['message']};
    } else {
      print("注册失败: ${response.body}");
      // 兼容fastapi detail字段
      String msg = "注册失败: ${response.body}";
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('detail')) {
          msg = body['detail'].toString();
        }
      } catch (_) {}
      return {"success": false, "message": msg};
    }
  }

  /// 注册信息补全
  Future<Map<String, dynamic>> completeRegisterInfo(
      Map<String, dynamic> info) async {
    final baseUrl = _getBaseUrl();
    final Map<String, dynamic> infoWithUsername =
        Map<String, dynamic>.from(info);
    // 确保username字段存在（调用时需传入）
    final requestBody = json.encode(infoWithUsername);

    print("发送注册信息补全请求到: $baseUrl/register?step=2");
    print("请求体: $requestBody");

    final response = await http.post(
      Uri.parse('$baseUrl/register?step=2'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print("补全返回: $responseBody");
      return {"success": true, "message": responseBody['message']};
    } else {
      print("补全失败: ${response.body}");
      String msg = "补全失败: ${response.body}";
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('detail')) {
          msg = body['detail'].toString();
        }
      } catch (_) {}
      return {"success": false, "message": msg};
    }
  }

  /// 获取分析页面的营养数据（蛋白质、钙质、饮水量等）
  Future<Map<String, dynamic>> fetchAnalysisData() async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/analysis/insight';
    final username = UserManager.instance.username;/// 先暂时用一个具体的值;
    final requestBody = json.encode({'username': username});
    print('发送到后端的信息: $requestBody'); // 打印发送内容
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    print('后端返回的原始内容: ${response.body}'); // 打印后端返回内容
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('获取分析数据失败: ${response.body}');
    }
  }

  /// 获取营养顾问历史消息或发送消息并获取最新消息
  Future<List<Map<String, dynamic>>> fetchAdvisorMessages(
      String message) async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/analysis/advisor/messages';
    final username = UserManager.instance.username;
    final String msg = (message.trim().isEmpty)
        ? '第一次回答时先给用户发送“您好，我是您的健康顾问”。之后不需要再发这句话'
        : message;
    final requestBody = json.encode({
      'username': username,
      'message': msg,
    });
    print('发送到后端的营养顾问信息: $requestBody');
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    print('后端返回的营养顾问信息: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 兼容 {"messages": [...]}, [{"role":...}], {"reply": "..." }
      if (data is Map && data.containsKey('messages')) {
        return List<Map<String, dynamic>>.from(data['messages']);
      }
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      if (data is Map && data.containsKey('reply')) {
        return [
          {"role": "assistant", "content": data['reply'] ?? ""}
        ];
      }
      return [];
    } else {
      throw Exception('获取营养顾问信息失败: ${response.body}');
    }
  }

  /// 获取饮食记录页面所有数据（新版diet_record_screen专用）
  Future<Map<String, dynamic>> fetchDietRecord({
    required String username,
    required String date,
  }) async {
    final baseUrl = _getBaseUrl();
    // 按照后端接口要求，使用 /record/currentMeals 作为路径
    final url = '$baseUrl/records/currentMeals';
    final requestBody = json.encode({'username': username, 'date': date});
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('获取饮食记录失败: ${response.body}');
    }
  }
}
