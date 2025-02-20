import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';
import '../models/video_watch_data.dart';

class VideoWatchDetails extends StatelessWidget {
  final List<VideoWatchData> videoWatchData;

  const VideoWatchDetails({
    super.key,
    required this.videoWatchData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: videoWatchData.map((video) => _buildVideoWatchItem(video)).toList(),
    );
  }

  Widget _buildVideoWatchItem(VideoWatchData video) {
    final watchedPercentage = (video.watchedDuration / video.totalDuration * 100).toInt();
    final hasAbnormalBehavior = video.skipCount > 0 || video.fastForwardCount > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(20)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  video.title,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (hasAbnormalBehavior)
                _buildAbnormalTag(),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(15)),
          LinearProgressIndicator(
            value: video.watchedDuration / video.totalDuration,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF88c5fd)),
            minHeight: ResponsiveSize.h(8),
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          _buildWatchInfo(watchedPercentage, video.lastWatchTime),
          if (hasAbnormalBehavior) ...[
            SizedBox(height: ResponsiveSize.h(10)),
            _buildAbnormalBehaviors(video),
          ],
        ],
      ),
    );
  }

  Widget _buildAbnormalTag() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(8),
        vertical: ResponsiveSize.h(4),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9E9E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
      ),
      child: Text(
        '异常',
        style: TextStyle(
          color: const Color(0xFFFF9E9E),
          fontSize: ResponsiveSize.sp(12),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWatchInfo(int watchedPercentage, String lastWatchTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '观看进度：$watchedPercentage%',
          style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: ResponsiveSize.sp(14),
          ),
        ),
        Text(
          '最后观看：$lastWatchTime',
          style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: ResponsiveSize.sp(14),
          ),
        ),
      ],
    );
  }

  Widget _buildAbnormalBehaviors(VideoWatchData video) {
    return Row(
      children: [
        if (video.skipCount > 0)
          _buildAbnormalBehaviorTag(
            '跳过 ${video.skipCount} 次',
            const Color(0xFFFF9E9E),
          ),
        if (video.skipCount > 0 && video.fastForwardCount > 0)
          SizedBox(width: ResponsiveSize.w(10)),
        if (video.fastForwardCount > 0)
          _buildAbnormalBehaviorTag(
            '快进 ${video.fastForwardCount} 次',
            const Color(0xFFFFB74D),
          ),
      ],
    );
  }

  Widget _buildAbnormalBehaviorTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(8),
        vertical: ResponsiveSize.h(4),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: ResponsiveSize.w(14),
            color: color,
          ),
          SizedBox(width: ResponsiveSize.w(4)),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveSize.sp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 