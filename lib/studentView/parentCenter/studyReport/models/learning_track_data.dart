class LearningTrackData {
  final String activity;    // 活动名称
  final String title;      // 活动标题
  final String timeSlot;   // 时间段
  final String content;    // 活动内容
  final double progress;   // 完成进度

  LearningTrackData({
    required this.activity,
    required this.title,
    required this.timeSlot,
    required this.content,
    required this.progress,
  });

  factory LearningTrackData.fromJson(Map<String, dynamic> json) {
    return LearningTrackData(
      activity: json['activity'] as String,
      title: json['title'] as String,
      timeSlot: json['timeSlot'] as String,
      content: json['content'] as String,
      progress: json['progress'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'title': title,
      'timeSlot': timeSlot,
      'content': content,
      'progress': progress,
    };
  }
} 