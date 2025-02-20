import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';

class AIReviewPanel extends StatelessWidget {
  final String aiEvaluation;
  final Function(String) onEvaluationChanged;
  final VoidCallback onAIReview;

  const AIReviewPanel({
    super.key,
    required this.aiEvaluation,
    required this.onEvaluationChanged,
    required this.onAIReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI点评内容',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI点评内容显示区域
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(12)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                ),
                child: aiEvaluation.isEmpty
                    ? Center(
                        child: Text(
                          '点击下方按钮开始AI点评',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: ResponsiveSize.sp(16),
                          ),
                        ),
                      )
                    : Text(
                        aiEvaluation,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: ResponsiveSize.sp(16),
                          height: 1.5,
                        ),
                      ),
              ),
              SizedBox(height: ResponsiveSize.h(16)),
              // 一键点评按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAIReview,
                  icon: Icon(
                    Icons.auto_awesome,
                    color: Colors.orange[700],
                    size: ResponsiveSize.w(20),
                  ),
                  label: Text(
                    '一键点评',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: ResponsiveSize.sp(16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSize.h(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      side: BorderSide(color: Colors.orange[700]!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 