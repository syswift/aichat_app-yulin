class DailyTask {
  final String taskName;
  final String taskNote;
  final int taskCount;
  final bool isFromQuestionBank;
  final List<String>? questionBankId;
  final Map<String, dynamic>? questionBankInfo;
  final String? id;

  DailyTask({
    required this.taskName,
    required this.taskNote,
    required this.taskCount,
    this.isFromQuestionBank = false,
    this.questionBankId,
    this.questionBankInfo,
    this.id,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      taskName: json['taskName'] as String,
      taskNote: json['taskNote'] as String,
      taskCount: json['taskCount'] as int,
      isFromQuestionBank: json['isFromQuestionBank'] as bool? ?? false,
      questionBankId: json['questionBankId'] as List<String>?,
      questionBankInfo: json['questionBankInfo'] as Map<String, dynamic>?,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskNote': taskNote,
      'taskCount': taskCount,
      'isFromQuestionBank': isFromQuestionBank,
      'questionBankId': questionBankId,
      'questionBankInfo': questionBankInfo,
      'id': id,
    };
  }

  String getDisplayText() {
    if (isFromQuestionBank) {
      return '$taskName\n$taskNote';
    }
    return '$taskName\n$taskNote';
  }
} 