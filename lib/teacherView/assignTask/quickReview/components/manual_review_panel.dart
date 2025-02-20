import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';

class ManualReviewPanel extends StatelessWidget {
  final String manualEvaluation;
  final Function(String) onEvaluationChanged;
  final String score;
  final Function(String) onScoreChanged;

  const ManualReviewPanel({
    super.key,
    required this.manualEvaluation,
    required this.onEvaluationChanged,
    required this.score,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '评分',
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
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: score,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '请输入分数(0-100)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    final number = int.tryParse(value);
                    if (number != null && number >= 0 && number <= 100) {
                      onScoreChanged(value);
                    }
                  },
                ),
              ),
              SizedBox(width: ResponsiveSize.w(8)),
              Text(
                '分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveSize.h(24)),
        Text(
          '普通点评内容',
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
          child: TextFormField(
            initialValue: manualEvaluation,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '请输入点评内容...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onEvaluationChanged,
          ),
        ),
      ],
    );
  }
} 