class ReviewContentModel {
  final String aiReview;
  final String manualReview;
  final String voiceReviewUrl;
  final int score;
  final String homeworkContent;
  final String homeworkImageUrl;

  ReviewContentModel({
    this.aiReview = '',
    this.manualReview = '',
    this.voiceReviewUrl = '',
    this.score = 0,
    this.homeworkContent = '',
    this.homeworkImageUrl = '',
  });

  factory ReviewContentModel.fromJson(Map<String, dynamic> json) {
    return ReviewContentModel(
      aiReview: json['aiReview'] ?? '',
      manualReview: json['manualReview'] ?? '',
      voiceReviewUrl: json['voiceReviewUrl'] ?? '',
      score: json['score'] ?? 0,
      homeworkContent: json['homeworkContent'] ?? '',
      homeworkImageUrl: json['homeworkImageUrl'] ?? '',
    );
  }

  bool get hasAiReview => aiReview.isNotEmpty;
  bool get hasManualReview => manualReview.isNotEmpty;
  bool get hasVoiceReview => voiceReviewUrl.isNotEmpty;
  bool get hasHomeworkImage => homeworkImageUrl.isNotEmpty;
} 