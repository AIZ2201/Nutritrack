import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final String username = "testuser";
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
            _buildNutritionInsightCard(),
            const SizedBox(height: 16),
            _buildNutritionAdvisorCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

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
              future: ApiService().fetchAnalysisData(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('加载失败: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('暂无分析数据'));
                }
                final data = snapshot.data!;
                final items = [
                  {
                    "label": "蛋白质",
                    "unit": "g",
                    "data": data["protein"] ??
                        {"value": 0, "status": "不足", "percent": 0}
                  },
                  {
                    "label": "钙质",
                    "unit": "mg",
                    "data": data["calcium"] ??
                        {"value": 0, "status": "不足", "percent": 0}
                  },
                  {
                    "label": "饮水量",
                    "unit": "ml",
                    "data": data["water"] ??
                        {"value": 0, "status": "不足", "percent": 0}
                  },
                ];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items.map((item) {
                    final d = item["data"] as Map<String, dynamic>;
                    final status = d["status"] ?? "不足";
                    final percent = d["percent"] ?? 0;
                    final value = d["value"] ?? 0;
                    final label = item["label"];
                    final unit = item["unit"];
                    final isGood = status == "良好";
                    return Expanded(
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
                            '$status',
                            style: TextStyle(
                              color: isGood
                                  ? const Color(0xFF5B6AF5)
                                  : Colors.orange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$value$unit',
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '您的$label摄入${status == "良好" ? "达到" : "低于"}目标的$percent%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
    return StatefulBuilder(
      builder: (context, setState) {
        Future<List<Map<String, dynamic>>> _fetchMessages() =>
            ApiService().fetchAdvisorMessages(username);

        void _sendMessage() async {
          final text = _controller.text.trim();
          if (text.isEmpty) return;
          await ApiService().sendAdvisorMessage(username, text);
          _controller.clear();
          setState(() {});
        }

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('加载失败: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('暂无对话'));
                      }
                      final messages = snapshot.data!;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, idx) {
                          final msg = messages[idx];
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
                                    ? const Color(0xFF5B6AF5).withOpacity(0.15)
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
                      );
                    },
                  ),
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
      },
    );
  }
}
