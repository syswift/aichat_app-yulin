enum MessageType {
  text,
  image,
  video,
  audio,
}
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;
  final String? thumbnailUrl;  // 添加缩略图URL字段
  final int? mediaDuration;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.thumbnailUrl,  // 添加到构造函数
    this.mediaDuration,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      mediaUrl: json['mediaUrl'],
      mediaDuration: json['mediaDuration'],
      thumbnailUrl: json['thumbnailUrl'],  // 从JSON解析缩略图URL
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'mediaDuration': mediaDuration,
      'thumbnailUrl': thumbnailUrl,  // 添加到JSON序列化
    };
  }
}