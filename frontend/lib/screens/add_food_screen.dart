import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../services/user_manager.dart'; // 新增导入

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  String? _selectedMealType;
  bool _isPhotoMode = true;
  bool _isRecognizing = false;
  bool _isPhotoTaken = false;
  String? _imageBase64;
  File? _imageFile;

  final List<String> _mealTypes = ['早餐', '午餐', '晚餐', '加餐']; // 页面显示带餐字

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '添加食物',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5B6AF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInputToggle(),
            _isPhotoMode ? _buildPhotoInput() : _buildManualInput(),
            const SizedBox(height: 16),
            _buildMealTypeSelector(),
            const SizedBox(height: 16),
            _buildNutritionInputs(),
            const SizedBox(height: 24),
            _buildAddButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // 输入模式切换
  Widget _buildInputToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPhotoMode = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isPhotoMode
                      ? const Color(0xFF5B6AF5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '拍照识别',
                    style: TextStyle(
                      color: _isPhotoMode ? Colors.white : Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPhotoMode = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isPhotoMode
                      ? const Color(0xFF5B6AF5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '手动输入',
                    style: TextStyle(
                      color: !_isPhotoMode ? Colors.white : Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 拍照输入模式
  Widget _buildPhotoInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: _isPhotoTaken
                ? _buildPhotoPreview()
                : _buildCameraPlaceholder(),
          ),
          // 新增：图片下方添加食物名称输入框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                labelText: '食物名称',
                hintText: '请输入食物名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 相机占位符
  Widget _buildCameraPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 64,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 16),
        Text(
          '拍摄或上传食物照片',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPhotoButton(Icons.camera_alt, '拍照', () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 80);
              if (pickedFile != null) {
                final bytes = await pickedFile.readAsBytes();
                setState(() {
                  _isPhotoTaken = true;
                  _imageBase64 = base64Encode(bytes);
                  _imageFile = File(pickedFile.path);
                });
                _simulatePhotoRecognition();
              }
            }),
            const SizedBox(width: 24),
            _buildPhotoButton(Icons.photo_library, '相册', () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery, imageQuality: 80);
              if (pickedFile != null) {
                final bytes = await pickedFile.readAsBytes();
                setState(() {
                  _isPhotoTaken = true;
                  _imageBase64 = base64Encode(bytes);
                  _imageFile = File(pickedFile.path);
                });
                _simulatePhotoRecognition();
              }
            }),
          ],
        ),
      ],
    );
  }

  // 照片按钮
  Widget _buildPhotoButton(
      IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF5B6AF5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5B6AF5),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // 照片预览
  Widget _buildPhotoPreview() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _isRecognizing
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF5B6AF5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '正在识别食物...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                : (_imageBase64 != null
                    ? Image.memory(
                        base64Decode(_imageBase64!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : const Icon(Icons.image, size: 64, color: Colors.grey)),
          ),
        ),
        // 重拍按钮
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isPhotoTaken = false;
                _isRecognizing = false;
                _imageFile = null;
                _imageBase64 = null;
                // 清空识别结果
                _foodNameController.clear();
                _caloriesController.clear();
                _proteinController.clear();
                _carbsController.clear();
                _fatController.clear();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 模拟照片识别过程
  void _simulatePhotoRecognition() {
    setState(() {
      _isRecognizing = true;
    });

    // 模拟识别延迟
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isRecognizing = false;
        // 填充模拟识别结果
        _foodNameController.text = '鸡胸肉沙拉';
        _caloriesController.text = '280';
        _proteinController.text = '28';
        _carbsController.text = '15';
        _fatController.text = '12';
        _selectedMealType = '午餐';
      });
    });
  }

  // 手动输入模式
  Widget _buildManualInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTextField(
            controller: _foodNameController,
            label: '食物名称',
            hintText: '请输入食物名称',
            icon: Icons.restaurant_menu,
          ),
        ],
      ),
    );
  }

  // 餐食类型选择器
  Widget _buildMealTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              '餐食类型',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: _mealTypes.map((type) {
                final isSelected = _selectedMealType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMealType = type;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5B6AF5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 营养成分输入
  Widget _buildNutritionInputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              '营养成分',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          _buildTextField(
            controller: _caloriesController,
            label: '热量',
            hintText: '0',
            icon: Icons.local_fire_department,
            suffix: 'kcal',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _proteinController,
                  label: '蛋白质',
                  hintText: '0',
                  suffix: 'g',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _carbsController,
                  label: '碳水',
                  hintText: '0',
                  suffix: 'g',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _fatController,
                  label: '脂肪',
                  hintText: '0',
                  suffix: 'g',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 文本输入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData? icon,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: const Color(0xFF5B6AF5),
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: label,
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (suffix != null)
              Text(
                suffix,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 添加按钮
  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () async {
          // 这里添加保存食物的逻辑
          final foodName = _foodNameController.text;
          final calories = double.tryParse(_caloriesController.text) ?? 0;
          final protein = double.tryParse(_proteinController.text) ?? 0;
          final carbon = double.tryParse(_carbsController.text) ?? 0;
          final fat = double.tryParse(_fatController.text) ?? 0;
          final mealType = _selectedMealType; // 仍然是'早餐'等
          final imageBase64 = _imageBase64 ?? "";

          if (foodName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('请填写食物名称')),
            );
            return;
          }
          if (mealType == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('请选择餐食类型')),
            );
            return;
          }
          // 直接传“早餐”“午餐”“晚餐”“加餐”给后端
          final success = await ApiService().uploadFoodRecord(
            foodName: foodName,
            protein: protein,
            fat: fat,
            carbon: carbon,
            calories: calories,
            time: mealType, // 直接传mealType
            image_base64: imageBase64,
          );
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('上传成功')),
            );
            Navigator.of(context).pop(true); // 返回true，主页可刷新
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('上传失败')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B6AF5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          '添加食物',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
