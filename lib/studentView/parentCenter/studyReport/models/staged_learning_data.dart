class StagedLearningData {
  final String level;
  final String week;
  final String taskType;
  final String taskName;
  final int duration;
  final String completionTime;
  final double score;

  StagedLearningData({
    required this.level,
    required this.week,
    required this.taskType,
    required this.taskName,
    required this.duration,
    required this.completionTime,
    required this.score,
  });

  factory StagedLearningData.fromJson(Map<String, dynamic> json) {
    return StagedLearningData(
      level: json['level'] as String,
      week: json['week'] as String,
      taskType: json['taskType'] as String,
      taskName: json['taskName'] as String,
      duration: json['duration'] as int,
      completionTime: json['completionTime'] as String,
      score: json['score'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'week': week,
      'taskType': taskType,
      'taskName': taskName,
      'duration': duration,
      'completionTime': completionTime,
      'score': score,
    };
  }
} 