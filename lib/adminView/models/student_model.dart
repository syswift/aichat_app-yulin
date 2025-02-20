class Student {
  String id;
  String name;
  String contact;
  String phone;
  List<String> classNames;
  String level;
  String planner;
  String? remark;
  DateTime joinDate;

  Student({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.classNames,
    required this.level,
    required this.planner,
    this.remark,
    required this.joinDate,
  });

  // 工厂构造函数，用于创建新学生
  factory Student.create({
    required String name,
    required String contact,
    required String phone,
    required List<String> classNames,
    required String level,
    required String planner,
    String? remark,
  }) {
    return Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      contact: contact,
      phone: phone,
      classNames: classNames,
      level: level,
      planner: planner,
      remark: remark,
      joinDate: DateTime.now(),
    );
  }

  // 从 JSON 创建学生对象
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      contact: json['contact'] as String,
      phone: json['phone'] as String,
      classNames: List.from(json['classNames'] as List<dynamic>),
      level: json['level'] as String,
      remark: json['remark'] as String? ?? '',
      planner: json['planner'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'phone': phone,
      'classNames': classNames,
      'level': level,
      'remark': remark,
      'planner': planner,
      'joinDate': joinDate.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    List<String>? classNames,
    String? level,
    String? planner,
    String? remark,
    DateTime? joinDate,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      classNames: classNames ?? this.classNames,
      level: level ?? this.level,
      planner: planner ?? this.planner,
      remark: remark ?? this.remark,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}