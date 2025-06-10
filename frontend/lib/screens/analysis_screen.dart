import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart'; // 新增导入

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;

  // 新增：只在页面初始化时加载一次分析数据
  late Future<Map<String, dynamic>> _insightFuture;

  @override
  void initState() {
    super.initState();
    _insightFuture = ApiService().fetchAnalysisData();
    _initMessages();
  }

  Future<void> _initMessages() async {
    setState(() {
      _loading = true;
    });
    try {
      final msgs = await ApiService().fetchAdvisorMessages('');
      setState(() {
        _messages = msgs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _messages = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '健康分析',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNutritionInsightCard(), // 只在页面初始化时加载
            const SizedBox(height: 16),
            _buildNutritionAdvisorCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // 只在页面初始化时加载分析数据
  Widget _buildNutritionInsightCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: const Color(0xFF5B6AF5), size: 20),
                const SizedBox(width: 8),
                const Text(
                  '营养洞察',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _insightFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载失败: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('暂无分析数据'));
                }
                final data = snapshot.data!;
                final analysis =
                    data['analysis'] as Map<String, dynamic>? ?? {};
                final items = [
                  {
                    "label": "卡路里",
                    "key": "calories",
                    "unit": "kcal",
                  },
                  {
                    "label": "蛋白质",
                    "key": "protein",
                    "unit": "g",
                  },
                  {
                    "label": "脂肪",
                    "key": "fat",
                    "unit": "g",
                  },
                  {
                    "label": "碳水",
                    "key": "carbon",
                    "unit": "g",
                  },
                ];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items.map((item) {
                    final key = item["key"]!;
                    final label = item["label"]!;
                    final unit = item["unit"]!;
                    final info = analysis[key] as Map<String, dynamic>? ?? {};
                    final target = info["目标"] ?? 0;
                    final intake = info["累计摄入"] ?? 0;
                    final status = info["状态"] ?? "";
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Text(
                              '$label',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$intake$unit',
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '目标: $target$unit',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$status',
                              style: TextStyle(
                                color: status.toString().contains('不足')
                                    ? Colors.orange
                                    : (status.toString().contains('过多')
                                        ? Colors.red
                                        : const Color(0xFF5B6AF5)),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionAdvisorCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent,
                    color: const Color(0xFF5B6AF5), size: 20),
                const SizedBox(width: 8),
                const Text(
                  '营养顾问',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '询问任何关于饮食和健康的问题',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_messages.isEmpty
                      ? const Center(child: Text('暂无对话'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, idx) {
                            final msg = _messages[idx];
                            final isUser = msg["role"] == "user";
                            return Container(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF5B6AF5)
                                          .withOpacity(0.15)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  msg["content"] ?? "",
                                  style: TextStyle(
                                    color: isUser
                                        ? const Color(0xFF5B6AF5)
                                        : const Color(0xFF1F2937),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '请输入您的问题...',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF5B6AF5), width: 1),
                      ),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF5B6AF5)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;
    setState(() {
      _messages.add({"role": "user", "content": text});
    });
    _controller.clear();
    try {
      final msgs = await ApiService().fetchAdvisorMessages(text);
      // 只取AI回复（假设后端返回的最后一条或唯一一条是AI回复）
      Map<String, dynamic>? aiReply;
      if (msgs.isNotEmpty) {
        // 取最后一条assistant消息
        aiReply = msgs.lastWhere(
          (m) => m["role"] == "assistant",
          orElse: () => msgs.last,
        );
      }
      if (aiReply != null) {
        setState(() {
          _messages.add(aiReply!);
        });
      }
    } catch (e) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    }
  }
}
