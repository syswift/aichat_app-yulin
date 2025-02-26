import 'package:livekit_client/livekit_client.dart';
import 'dart:async';

class LiveKitRoomService {
  final Room room = Room();
  String? _connectionError;
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  String? get connectionError => _connectionError;

  Future<bool> connectToRoom(String wsUrl, String token) async {
    try {
      _connectionError = null;

      // Set up room event listeners before connecting
      final listener = room.createListener();
      listener.on<RoomEvent>(_onRoomEvent);

      await room.connect(wsUrl, token);
      _isConnected = true;
      return true;
    } catch (e) {
      _connectionError = e.toString();
      _isConnected = false;
      return false;
    }
  }

  void _onRoomEvent(RoomEvent event) {
    if (event is RoomDisconnectedEvent) {
      _isConnected = false;
    } else if (event is RoomConnectedEvent) {
      _isConnected = true;
    }
    // Handle other room events as needed
  }

  void disconnect() {
    room.disconnect();
    // Listeners created with createListener are automatically disposed when the room is disconnected
    _isConnected = false;
  }
}
