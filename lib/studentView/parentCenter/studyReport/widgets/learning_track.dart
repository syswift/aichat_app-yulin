import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';
import '../models/learning_track_data.dart';

class LearningTrack extends StatelessWidget {
  final List<LearningTrackData> learningTracks;

  const LearningTrack({
    super.key,
    required this.learningTracks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '学习轨迹',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          ...learningTracks.map((track) => _buildTrackItem(track)),
        ],
      ),
    );
  }

  Widget _buildTrackItem(LearningTrackData track) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(15)),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.w(12),
            height: ResponsiveSize.h(12),
            decoration: const BoxDecoration(
              color: Color(0xFF88c5fd),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: ResponsiveSize.w(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.activity,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(5)),
                Text(
                  '${track.title} (${track.timeSlot})',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveSize.sp(14),
                  ),
                ),
                if (track.content.isNotEmpty) ...[
                  SizedBox(height: ResponsiveSize.h(5)),
                  Text(
                    track.content,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveSize.sp(14),
                    ),
                  ),
                ],
                SizedBox(height: ResponsiveSize.h(8)),
                LinearProgressIndicator(
                  value: track.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF88c5fd)),
                  minHeight: ResponsiveSize.h(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 