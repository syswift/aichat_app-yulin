import 'package:flutter/material.dart';
import './review_detail_page.dart';
import '../../../utils/responsive_size.dart';
import './review_content_page.dart';

enum ReviewStatus {
  all('全部', Colors.grey),
  pending('待检查', Colors.orange),
  reviewed('已点评', Colors.green);

  final String label;
  final Color bgColor;
  const ReviewStatus(this.label, this.bgColor);

  Color get textColor => this == ReviewStatus.all 
      ? Colors.black87 
      : Colors.white;
}

class ReviewItem {
  final String student;
  final String task;
  final String uploadTime;
  ReviewStatus status;

  ReviewItem({
    required this.student,
    required this.task,
    required this.uploadTime,
    required this.status,
  });
}

class HeaderItem {
  final String title;
  final int flex;

  HeaderItem({
    required this.title,
    required this.flex,
  });
}

class QuickReviewPage extends StatefulWidget {
  const QuickReviewPage({super.key});

  @override
  State<QuickReviewPage> createState() => _QuickReviewPageState();
}

class _QuickReviewPageState extends State<QuickReviewPage> {
  ReviewStatus _selectedStatus = ReviewStatus.all;
  final Set<ReviewItem> _selectedItems = {};
  bool _isSelectionMode = false;

  final List<ReviewItem> _reviews = [
    ReviewItem(
      student: '张三',
      task: '大灰狼',
      uploadTime: '2024/03/15 14:30',
      status: ReviewStatus.pending,
    ),
    ReviewItem(
      student: '李四',
      task: '写作：我的暑假',
      uploadTime: '2024/03/14 16:45',
      status: ReviewStatus.reviewed,
    ),
  ];

  final List<HeaderItem> headers = [
    HeaderItem(title: '学员', flex: 2),
    HeaderItem(title: '任务', flex: 3),
    HeaderItem(title: '上传时间', flex: 2),
    HeaderItem(title: '状态', flex: 1),
    HeaderItem(title: '操作', flex: 1),
  ];

  List<ReviewItem> get _filteredReviews {
    if (_selectedStatus == ReviewStatus.all) {
      return _reviews;
    }
    return _reviews.where((review) => review.status == _selectedStatus).toList();
  }

  void _openReviewDetail(ReviewItem review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailPage(
          reviewItem: review,
          onReviewSubmitted: () {
            // 立即更新状态
            setState(() {
              // 如果需要，这里可以添加其他更新逻辑
            });
          },
        ),
      ),
    );
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
    bool showConfirmButton = false,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
          ),
        ),
        actions: [
          if (showConfirmButton)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '确定',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _batchAIReview() async {
    if (_selectedItems.isEmpty) {
      await _showMessageDialog(
        title: '提示',
        message: '请先选择需要点评的作业',
        showConfirmButton: true,
      );
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '批量AI点评',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '确定要对选中的 ${_selectedItems.length} 份作业进行AI点评吗？',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '确定',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: ResponsiveSize.h(16)),
              Text(
                '正在进行AI点评...',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                ),
              ),
            ],
          ),
        ),
      );

      try {
        await Future.delayed(Duration(seconds: 2));
        
        Navigator.pop(context);

        setState(() {
          for (var item in _selectedItems) {
            item.status = ReviewStatus.reviewed;
          }
          _selectedItems.clear();
          _isSelectionMode = false;
        });

        await _showMessageDialog(
          title: '成功',
          message: 'AI点评已完成',
          showConfirmButton: true,
        );
      } catch (e) {
        Navigator.pop(context);
        
        await _showMessageDialog(
          title: '错误',
          message: 'AI点评失败：$e',
          showConfirmButton: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveSize.w(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '快速点评',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(28),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              Row(
                children: [
                  if (_isSelectionMode) ...[
                    TextButton.icon(
                      onPressed: _batchAIReview,
                      icon: Icon(Icons.auto_awesome, color: Colors.blue),
                      label: Text(
                        'AI批量点评',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(16)),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedItems.clear();
                          _isSelectionMode = false;
                        });
                      },
                      icon: Icon(Icons.close, color: Colors.grey),
                      label: Text(
                        '取消选择',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ] else ...[
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSelectionMode = true;
                        });
                      },
                      icon: Icon(Icons.check_box_outlined, color: Colors.blue),
                      label: Text(
                        '批量选择',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.h(16),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4C4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: ResponsiveSize.w(10),
                      offset: Offset(0, ResponsiveSize.h(4)),
                    ),
                  ],
                ),
                child: Row(
                  children: headers.map((header) => _buildHeader(header)).toList(),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
                    itemCount: _filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = _filteredReviews[index];
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: ResponsiveSize.h(12)),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.h(20),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: ResponsiveSize.w(10),
                              offset: Offset(0, ResponsiveSize.h(4)),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (_isSelectionMode)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
                                child: Checkbox(
                                  value: _selectedItems.contains(review),
                                  onChanged: review.status == ReviewStatus.pending
                                      ? (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedItems.add(review);
                                            } else {
                                              _selectedItems.remove(review);
                                            }
                                          });
                                        }
                                      : null,
                                ),
                              ),
                            _buildCell(review.student, 2),
                            _buildCell(review.task, 3),
                            _buildCell(review.uploadTime, 2),
                            _buildStatusCell(review),
                            _buildActionCell(review),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCell(ReviewItem review) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(12),
            vertical: ResponsiveSize.h(6),
          ),
          decoration: BoxDecoration(
            color: review.status.bgColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          ),
          child: Text(
            review.status.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: review.status.bgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCell(ReviewItem review) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _openReviewDetail(review),
              child: Text(
                '点评',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (review.status == ReviewStatus.reviewed)
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewContentPage(
                      reviewItem: review,
                    ),
                  ),
                ),
                child: Text(
                  '查看',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(20),
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HeaderItem header) {
    if (header.title == '状态') {
      return Expanded(
        flex: header.flex,
        child: Center(
          child: PopupMenuButton<ReviewStatus>(
            initialValue: _selectedStatus,
            offset: Offset(ResponsiveSize.w(20), ResponsiveSize.h(20)),
            position: PopupMenuPosition.under,
            constraints: BoxConstraints(
              minWidth: ResponsiveSize.w(120),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
            onSelected: (ReviewStatus status) {
              setState(() {
                _selectedStatus = status;
              });
            },
            itemBuilder: (BuildContext context) {
              return ReviewStatus.values.map((ReviewStatus status) {
                return PopupMenuItem<ReviewStatus>(
                  value: status,
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedStatus.label,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(25),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: ResponsiveSize.w(24),
                  color: const Color(0xFF333333),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      flex: header.flex,
      child: Center(
        child: Text(
          header.title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(25),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}