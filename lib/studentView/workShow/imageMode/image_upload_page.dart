import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

class ImageUploadPage extends StatefulWidget {
  final Function(String title, String imagePath)? onSaveWork;

  const ImageUploadPage({
    super.key,
    this.onSaveWork,
  });

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final TextEditingController _titleController = TextEditingController();
  String? _imagePath;
  bool _hasImage = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        String originalPath = image.path;
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String savedPath = '${appDir.path}/$imageName';

        await File(originalPath).copy(savedPath);
        setState(() {
          _imagePath = savedPath;
          _hasImage = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('选择图片失败')),
        );
      }
    }
  }

  void _handleSave() {
    if (!_hasImage || _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择图片')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '保存作品',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: ResponsiveSize.w(500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: ResponsiveSize.sp(24)),
                decoration: InputDecoration(
                  labelText: '作品名称',
                  labelStyle: TextStyle(fontSize: ResponsiveSize.sp(24)),
                  hintText: '请输入作品名称',
                  hintStyle: TextStyle(fontSize: ResponsiveSize.sp(22)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20),
                    vertical: ResponsiveSize.h(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入作品名称')),
                );
                return;
              }
              
              // 调用保存回调
              widget.onSaveWork?.call(_titleController.text, _imagePath!);
              
              // 关闭对话框
              Navigator.pop(context);
              
              // 重置状态
              setState(() {
                _hasImage = false;
                _imagePath = null;
                _titleController.clear();
              });
              
              // 显示成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('作品保存成功')),
              );
            },
            child: Text(
              '保存',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
        ],
      ),
    );
}
  Widget _buildStyledButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(30),
          vertical: ResponsiveSize.h(12),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFA7),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
          border: Border.all(
            color: const Color(0xFFFFCC80),
            width: ResponsiveSize.w(2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(26),
            color: const Color(0xFF5A2E17),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/backbutton1.png',
                        width: ResponsiveSize.w(90),
                        height: ResponsiveSize.h(90),
                      ),
                    ),
                    Text(
                      '上传图片',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(30),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A2E17),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: ResponsiveSize.w(15)),
                          child: _buildStyledButton(
                            '分享',
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('分享功能开发中')),
                              );
                            },
                          ),
                        ),
                        _buildStyledButton('保存', _handleSave),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_hasImage)
                        Container(
                          width: ResponsiveSize.w(400),
                          height: ResponsiveSize.h(300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                            border: Border.all(
                              color: const Color(0xFFFFDFA7),
                              width: ResponsiveSize.w(2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                            child: Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: ResponsiveSize.w(400),
                          height: ResponsiveSize.h(300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                            border: Border.all(
                              color: const Color(0xFFFFDFA7),
                              width: ResponsiveSize.w(2),
                            ),
                          ),
                          child: Icon(
                            Icons.image,
                            size: ResponsiveSize.w(120),
                            color: const Color(0xFF5A2E17).withOpacity(0.3),
                          ),
                        ),
                      SizedBox(height: ResponsiveSize.h(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStyledButton(
                            '拍照',
                            () => _pickImage(ImageSource.camera),
                          ),
                          SizedBox(width: ResponsiveSize.w(20)),
                          _buildStyledButton(
                            '选择图片',
                            () => _pickImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}