import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/responsive_size.dart';

class WritingHomeworkPage extends StatefulWidget {
  final Map<String, dynamic> homework;

  const WritingHomeworkPage({
    super.key,
    required this.homework,
  });

  @override
  State<WritingHomeworkPage> createState() => _WritingHomeworkPageState();
}

class _WritingHomeworkPageState extends State<WritingHomeworkPage> {
  final TextEditingController _answerController = TextEditingController();
  final List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _imageFiles.add(File(image.path));
        });
      }
    } catch (e) {
      _showError(source == ImageSource.camera ? '拍照失败' : '选择图片失败');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showImagePreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(_imageFiles[index]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitHomework() async {
  if (_answerController.text.isEmpty && _imageFiles.isEmpty) {
    _showError('请输入答案或上传图片');
    return;
  }
  
  // Update homework status and data
  widget.homework['status'] = '已完成';
  widget.homework['answer'] = _answerController.text;
  widget.homework['images'] = _imageFiles.map((file) => file.path).toList();
  
  bool isDialogOpen = true;
  
  // 显示成功弹窗
  showDialog(
    context: context,
    barrierDismissible: true, // 允许点击外部关闭
    builder: (BuildContext context) {
      // 3秒后自动关闭
      Future.delayed(const Duration(seconds: 3), () {
        if (isDialogOpen && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
      
      return WillPopScope(
        onWillPop: () async {
          isDialogOpen = false;
          return true;
        },
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          ),
          child: Container(
            width: ResponsiveSize.w(300),
            padding: EdgeInsets.all(ResponsiveSize.w(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(16)),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: ResponsiveSize.w(40),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(20)),
                Text(
                  '提交成功！',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(10)),
                Text(
                  '你的作业已经提交成功',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(20)),
                TextButton(
                  onPressed: () {
                    isDialogOpen = false;
                    Navigator.of(context).pop(); // 关闭弹窗
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((_) {
    // 弹窗关闭后返回上一页
    if (mounted) {  // 确保 widget 还在树中
      Navigator.pop(context, widget.homework);
    }
  });
}

  Widget _buildStatusTag(String status) {
    Color tagColor;
    switch (status) {
      case '未完成':
        tagColor = Colors.red;
        break;
      case '有点评':
        tagColor = Colors.blue;
        break;
      case '已完成':
        tagColor = Colors.green;
        break;
      default:
        tagColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(12),
        vertical: ResponsiveSize.h(6),
      ),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        border: Border.all(
          color: tagColor.withOpacity(0.5),
          width: ResponsiveSize.w(1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == '已完成' ? Icons.check_circle :
            status == '有点评' ? Icons.comment :
            Icons.access_time,
            color: tagColor,
            size: ResponsiveSize.w(16),
          ),
          SizedBox(width: ResponsiveSize.w(4)),
          Text(
            status,
            style: TextStyle(
              color: tagColor,
              fontSize: ResponsiveSize.sp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
@override
Widget build(BuildContext context) {
  ResponsiveSize.init(context);
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fsbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(20),
                vertical: ResponsiveSize.h(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/backbutton1.png',
                          width: ResponsiveSize.w(100),
                          height: ResponsiveSize.h(100),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(100)),
                    ],
                  ),
                  Text(
                    widget.homework['title'],
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A2E17),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveSize.w(20)),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.all(ResponsiveSize.w(25)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(10),
                        offset: Offset(0, ResponsiveSize.h(5)),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusTag(widget.homework['status']),
                          Text(
                            '截止日期：${widget.homework['dueDate']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(25)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(25),
                          vertical: ResponsiveSize.h(30),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.homework['content'],
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(22),
                            color: Colors.black87,
                            height: 1.8,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(ResponsiveSize.w(15)),
                              child: Text(
                                '作答区域',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey[300]),
                            if (_imageFiles.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.all(ResponsiveSize.w(10)),
                                child: Wrap(
                                  spacing: ResponsiveSize.w(10),
                                  runSpacing: ResponsiveSize.h(10),
                                  children: List.generate(
                                    _imageFiles.length,
                                    (index) => Container(
                                      padding: EdgeInsets.all(ResponsiveSize.w(8)),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () => _showImagePreview(index),
                                            child: Container(
                                              width: ResponsiveSize.w(30),
                                              height: ResponsiveSize.w(30),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                                image: DecorationImage(
                                                  image: FileImage(_imageFiles[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: ResponsiveSize.w(8)),
                                          Text(
                                            '图片 ${index + 1}',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(18),
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(width: ResponsiveSize.w(8)),
                                          GestureDetector(
                                            onTap: () => _removeImage(index),
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: ResponsiveSize.w(24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (_imageFiles.isNotEmpty)
                              Divider(height: 1, color: Colors.grey[300]),
                            Padding(
                              padding: EdgeInsets.all(ResponsiveSize.w(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: _answerController,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      hintText: '请输入你的答案...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(ResponsiveSize.w(15)),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(15)),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: ResponsiveSize.w(80),
                                        height: ResponsiveSize.h(36),
                                        child: ElevatedButton(
                                          onPressed: () => _pickImage(ImageSource.gallery),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFFDFA7),
                                            foregroundColor: const Color(0xFF5A2E17),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                                            ),
                                          ),
                                          child: const Icon(Icons.photo_library, size: 20),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(10)),
                                      SizedBox(
                                        width: ResponsiveSize.w(80),
                                        height: ResponsiveSize.h(36),
                                        child: ElevatedButton(
                                          onPressed: () => _pickImage(ImageSource.camera),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFFDFA7),
                                            foregroundColor: const Color(0xFF5A2E17),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                                            ),
                                          ),
                                          child: const Icon(Icons.camera_alt, size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(20)),
              child: SizedBox(
                width: ResponsiveSize.w(120),
                height: ResponsiveSize.h(40),
                child: ElevatedButton(
                  onPressed: _submitHomework,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    ),
                  ),
                  child: const Text('提交'),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}