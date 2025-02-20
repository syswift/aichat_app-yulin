import 'student_model.dart';

class ClassInfo {
  final String id;
  final String name;
  final String grade;
  final String? note;
  final String? teacher;
  final int studentCount;
  final DateTime createdAt;
  final List<Student> students;

  ClassInfo({
    required this.id,
    required this.name,
    required this.grade,
    this.note,
    this.teacher,
    required this.studentCount,
    required this.createdAt,
    this.students = const [],
  });

  ClassInfo copyWith({
    String? id,
    String? name,
    String? grade,
    String? note,
    String? teacher,
    int? studentCount,
    DateTime? createdAt,
    List<Student>? students,
  }) {
    return ClassInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      note: note ?? this.note,
      teacher: teacher ?? this.teacher,
      studentCount: studentCount ?? this.studentCount,
      createdAt: createdAt ?? this.createdAt,
      students: students ?? this.students,
    );
  }

  factory ClassInfo.create({
    required String name,
    required String grade,
    String? note,
    String? teacher,
    required int studentCount,
    List<Student> students = const [],
  }) {
    return ClassInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      grade: grade,
      note: note,
      teacher: teacher,
      studentCount: studentCount,
      createdAt: DateTime.now(),
      students: students,
    );
  }
}