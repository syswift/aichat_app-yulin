class VideoWatchData {
  final String title;           
  final int totalCount;         
  final int completedCount;      
  final double completionRate;   
  final int totalDuration;       
  final int watchedDuration;     
  final int skipCount;          
  final int fastForwardCount;   
  final String lastWatchTime;   // 改为 String 类型

  const VideoWatchData({
    required this.title,
    required this.totalCount,
    required this.completedCount,
    required this.completionRate,
    required this.totalDuration,
    required this.watchedDuration,
    required this.skipCount,
    required this.fastForwardCount,
    required this.lastWatchTime,
  });

  factory VideoWatchData.fromJson(Map<String, dynamic> json) {
    return VideoWatchData(
      title: json['title'] as String,
      totalCount: json['totalCount'] as int,
      completedCount: json['completedCount'] as int,
      completionRate: json['completionRate'] as double,
      totalDuration: json['totalDuration'] as int,
      watchedDuration: json['watchedDuration'] as int,
      skipCount: json['skipCount'] as int,
      fastForwardCount: json['fastForwardCount'] as int,
      lastWatchTime: json['lastWatchTime'] as String,  // 直接使用字符串
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'totalCount': totalCount,
      'completedCount': completedCount,
      'completionRate': completionRate,
      'totalDuration': totalDuration,
      'watchedDuration': watchedDuration,
      'skipCount': skipCount,
      'fastForwardCount': fastForwardCount,
      'lastWatchTime': lastWatchTime,  // 直接使用字符串
    };
  }
} 