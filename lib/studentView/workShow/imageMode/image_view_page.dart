import 'dart:io';
import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'package:intl/intl.dart';

class ImageViewPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final DateTime? createTime;
  final String? teacherComment;
  final DateTime? commentTime;

  const ImageViewPage({
    super.key,
    required this.title,
    required this.imagePath,
    this.createTime,
    this.teacherComment,
    this.commentTime,
  });

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  bool _showInfo = true;

  String _getWeeksInApp() {
    if (widget.createTime == null) return '0周';
    final now = DateTime.now();
    final difference = now.difference(widget.createTime!);
    final weeks = (difference.inDays / 7).ceil();
    return '$weeks周';
  }

  String _getFormattedDate() {
    if (widget.createTime == null) return '未知时间';
    return DateFormat('yyyy年MM月dd日').format(widget.createTime!);
  }

    Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(8)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1D6),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          ),
          child: Icon(
            icon,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF5A2E17),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(4)),
              Text(
                content,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: _showInfo ? ResponsiveSize.w(20) : -ResponsiveSize.w(300),
      top: ResponsiveSize.h(20),
      child: Container(
        width: ResponsiveSize.w(300),
        padding: EdgeInsets.all(ResponsiveSize.w(15)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(2),
          ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '作品信息',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A2E17),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showInfo = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(5)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDFA7),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    ),
                    child: Icon(
                      Icons.close,
                      size: ResponsiveSize.w(20),
                      color: const Color(0xFF5A2E17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(15)),
            _buildInfoItem(
              icon: Icons.calendar_today,
              title: '完成日期',
              content: _getFormattedDate(),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            _buildInfoItem(
              icon: Icons.timer,
              title: '鹅爸爸陪伴',
              content: _getWeeksInApp(),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            if (widget.teacherComment != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1D6),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    ),
                    child: Icon(
                      Icons.rate_review,
                      size: ResponsiveSize.w(20),
                      color: const Color(0xFF5A2E17),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '老师点评',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(18),
                                color: Colors.grey[600],
                              ),
                            ),
                            if (widget.commentTime != null)
                              Text(
                                DateFormat('MM-dd').format(widget.commentTime!),
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(16),
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: ResponsiveSize.h(4)),
                        Text(
                          widget.teacherComment!,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5A2E17),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoToggle() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: _showInfo ? -ResponsiveSize.w(50) : ResponsiveSize.w(20),
      top: ResponsiveSize.h(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showInfo = true;
          });
        },
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.w(12)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border.all(
              color: const Color(0xFFFFDFA7),
              width: ResponsiveSize.w(2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: ResponsiveSize.w(5),
                offset: Offset(0, ResponsiveSize.h(2)),
              ),
            ],
          ),
          child: Icon(
            Icons.info_outline,
            size: ResponsiveSize.w(24),
            color: const Color(0xFF5A2E17),
          ),
        ),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // 顶部导航栏
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(20),
                      vertical: ResponsiveSize.h(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,  // 确保标题居中
                      children: [
                        // 返回按钮靠左
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/backbutton1.png',
                              width: ResponsiveSize.w(90),
                              height: ResponsiveSize.h(90),
                            ),
                          ),
                        ),
                        // 标题居中
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(100),  // 给两边留出空间，避免与返回按钮重叠
                          ),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(32),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5A2E17),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  
                  // 图片展示区域
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(ResponsiveSize.w(20)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                          border: Border.all(
                            color: const Color(0xFFFFDFA7),
                            width: ResponsiveSize.w(2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: ResponsiveSize.w(10),
                              offset: Offset(0, ResponsiveSize.h(5)),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                          child: Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _buildInfoPanel(),
              _buildInfoToggle(),
            ],
          ),
        ),
      ),
    );
  }
}