class Teacher {
  final String id;
  final String name;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  Teacher({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }
}