class TaskItem {
  final String id;
  final String title;
  final String status;
  final DateTime submitTime;
  final int? score;

  TaskItem({
    required this.id,
    required this.title,
    required this.status,
    required this.submitTime,
    this.score,
  });
} 