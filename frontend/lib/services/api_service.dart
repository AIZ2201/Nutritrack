import 'dart:async';
import 'dart:convert'; // 添加此行以支持 JSON 解码
import 'package:http/http.dart' as http;

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
        return 'http://10.203.180.154:8000'; // 异地模式地址
      case BackendMode.server:
        return 'http://123.60.149.85:8000'; // 服务器模式地址
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    if (backendMode == BackendMode.local && useMock) {
      return _mockLogin(username, password);
    } else {
      final baseUrl = _getBaseUrl(); // 根据模式获取后端地址
      final requestBody = json
          .encode({'username': username, 'password': password}); // 构建 JSON 数据
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
          "success": responseBody['message'] == "login_successful!",
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
  Future<Map<String, dynamic>> fetchMealsByDate(
      String username, String date) async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/homePage/todayMeals';
    final requestBody = json.encode({'username': username, 'date': date});
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
    required String username,
    required String foodName,
    required double protein,
    required double fat,
    required double carbon,
    required double calorie,
    required String time,
    required String imageBase64,
  }) async {
    final baseUrl = _getBaseUrl();
    final url = '$baseUrl/records/upload'; // 修改为正确的上传路径
    final body = json.encode({
      'username': username,
      'foodName': foodName,
      'protain': protein, // 注意拼写
      'fat': fat,
      'carbon': carbon,
      'calorie': calorie,
      'time': time,
      'image_base64': imageBase64,
    });
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
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
      return {"success": false, "message": "注册失败: ${response.body}"};
    }
  }

  /// 注册信息补全
  Future<Map<String, dynamic>> completeRegisterInfo(
      Map<String, dynamic> info) async {
    final baseUrl = _getBaseUrl();
    final Map<String, dynamic> infoWithUsername = Map<String, dynamic>.from(info);
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
      return {"success": false, "message": "补全失败: ${response.body}"};
    }
  }
}
