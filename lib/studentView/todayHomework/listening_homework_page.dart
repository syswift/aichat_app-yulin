import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class ListeningHomeworkPage extends StatefulWidget {
  final Map<String, dynamic> homework;

  const ListeningHomeworkPage({
    super.key,
    required this.homework,
  });

  @override
  State<ListeningHomeworkPage> createState() => _ListeningHomeworkPageState();
}

class _ListeningHomeworkPageState extends State<ListeningHomeworkPage> {
  final TextEditingController _answerController = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _submitHomework() async {
  widget.homework['status'] = '已完成';
  
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
                    widget.homework['title'] ?? '',
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
                          _buildStatusTag(widget.homework['status'] ?? '未完成'),
                          Text(
                            '截止日期：${widget.homework['dueDate'] ?? ''}',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.homework['content'] ?? '暂无内容',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(22),
                                color: Colors.black87,
                                height: 1.8,
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(20)),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(ResponsiveSize.w(15)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.play_circle_filled, 
                                       color: const Color(0xFF4A90E2),
                                       size: ResponsiveSize.w(40)),
                                  SizedBox(width: ResponsiveSize.w(10)),
                                  Text('听力音频',
                                       style: TextStyle(
                                         fontSize: ResponsiveSize.sp(20),
                                         color: Colors.black87,
                                       )),
                                ],
                              ),
                            ),
                          ],
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
                            Padding(
                              padding: EdgeInsets.all(ResponsiveSize.w(15)),
                              child: TextField(
                                controller: _answerController,
                                maxLines: 8,
                                decoration: InputDecoration(
                                  hintText: '请输入你的答案...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(ResponsiveSize.w(15)),
                                ),
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