class FreeLearningData {
  final String category;
  final String title;
  final int duration;
  final String lastWatchTime;
  final double progress;

  FreeLearningData({
    required this.category,
    required this.title,
    required this.duration,
    required this.lastWatchTime,
    required this.progress,
  });

  factory FreeLearningData.fromJson(Map<String, dynamic> json) {
    return FreeLearningData(
      category: json['category'] as String,
      title: json['title'] as String,
      duration: json['duration'] as int,
      lastWatchTime: json['lastWatchTime'] as String,
      progress: json['progress'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'duration': duration,
      'lastWatchTime': lastWatchTime,
      'progress': progress,
    };
  }
} 