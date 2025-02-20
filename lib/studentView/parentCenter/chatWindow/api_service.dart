import 'dart:io';

import '../platform_notification_page.dart';
import 'chat_message.dart';
import 'teacher.dart';

class ApiService {
  static Future<List<NotificationItem>> getNotifications() async {
    // TODO: 实现获取通知列表的API调用
    throw UnimplementedError();
  }

  static Future<Teacher> getTeacher() async {
    // TODO: 实现获取教师信息的API调用
    throw UnimplementedError();
  }

  static Future<List<ChatMessage>> getChatMessages(String teacherId) async {
    // TODO: 实现获取聊天记录的API调用
    throw UnimplementedError();
  }

  static Future<String> sendMessage(ChatMessage message) async {
    // TODO: 实现发送消息的API调用
    throw UnimplementedError();
  }

  static Future<String> uploadFile(File file, String type) async {
    // TODO: 实现文件上传的API调用
    throw UnimplementedError();
  }
}