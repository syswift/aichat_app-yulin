import '../utils/time_display_helper.dart';

class TimeData {
  final String day;  // 原来是 timeSlot
  final int minutes;

  const TimeData({
    required this.day,
    required this.minutes,
  });

  String getDisplayTime(String reportType) {
    return TimeDisplayHelper.getTimeLabel(reportType, day);
  }

  factory TimeData.fromJson(Map<String, dynamic> json) {
    return TimeData(
      day: json['day'] as String,
      minutes: json['minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'minutes': minutes,
    };
  }
} 