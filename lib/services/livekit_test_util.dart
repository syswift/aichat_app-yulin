import 'package:flutter/material.dart';
import 'livekit_room_service.dart';

class LiveKitTester {
  static Future<void> testConnection(
    BuildContext context,
    String wsUrl,
    String token,
  ) async {
    final service = LiveKitRoomService();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Try to connect
    final success = await service.connectToRoom(wsUrl, token);

    // Hide loading indicator
    Navigator.of(context).pop();

    // Show result
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(success ? '连接成功' : '连接失败'),
            content: Text(
              success
                  ? '成功连接到LiveKit服务器'
                  : '连接LiveKit服务器失败: ${service.connectionError}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (success) service.disconnect();
                },
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }
}
