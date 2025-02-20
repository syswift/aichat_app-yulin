class Staff {
  final String id;
  final String name;
  final String gender;
  final int age;
  final String username;
  List<String> classes;
  String role;
  final int workYears;
  final String phone;
  final bool hasEditPermission;
  final DateTime joinDate;
  final String campus;

  Staff({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.username,
    required this.classes,
    required this.role,
    required this.workYears,
    required this.phone,
    required this.hasEditPermission,
    required this.joinDate,
    required this.campus,
  });

  factory Staff.create({
    required String name,
    required String gender,
    required int age,
    required String role,
    required String phone,
    required DateTime joinDate,
    required String campus,
  }) {
    return Staff(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      gender: gender,
      age: age,
      username: name.toLowerCase().replaceAll(' ', ''),
      classes: [],
      role: role,
      workYears: 0,
      phone: phone,
      hasEditPermission: false,
      joinDate: joinDate,
      campus: campus,
    );
  }
}