import 'learning_track_data.dart';
import 'time_data.dart';
import 'video_watch_data.dart';
import 'free_learning_data.dart';
import 'staged_learning_data.dart';

class StudyReportData {
  final String title;
  final List<TimeData> timeData;
  final List<LearningTrackData> learningTracks;
  final List<VideoWatchData> videoWatchData;
  final List<FreeLearningData> freeLearningData;
  final List<StagedLearningData> stagedLearningData;
  final DateTime reportDate;
  final String reportType;

  StudyReportData({
    required this.title,
    required this.timeData,
    required this.learningTracks,
    required this.videoWatchData,
    required this.freeLearningData,
    required this.stagedLearningData,
    required this.reportDate,
    required this.reportType,
  });

  factory StudyReportData.fromJson(Map<String, dynamic> json) {
    return StudyReportData(
      title: json['title'] as String,
      timeData: (json['timeData'] as List)
          .map((e) => TimeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      learningTracks: (json['learningTracks'] as List)
          .map((e) => LearningTrackData.fromJson(e as Map<String, dynamic>))
          .toList(),
      videoWatchData: (json['videoWatchData'] as List)
          .map((e) => VideoWatchData.fromJson(e as Map<String, dynamic>))
          .toList(),
      freeLearningData: (json['freeLearningData'] as List)
          .map((e) => FreeLearningData.fromJson(e as Map<String, dynamic>))
          .toList(),
      stagedLearningData: (json['stagedLearningData'] as List)
          .map((e) => StagedLearningData.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportDate: DateTime.parse(json['reportDate'] as String),
      reportType: json['reportType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timeData': timeData.map((e) => e.toJson()).toList(),
      'learningTracks': learningTracks.map((e) => e.toJson()).toList(),
      'videoWatchData': videoWatchData.map((e) => e.toJson()).toList(),
      'freeLearningData': freeLearningData.map((e) => e.toJson()).toList(),
      'stagedLearningData': stagedLearningData.map((e) => e.toJson()).toList(),
      'reportDate': reportDate.toIso8601String(),
      'reportType': reportType,
    };
  }
} 