import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  LocalParticipant? _localParticipant;
  RemoteParticipant? _aiAgent;

  final StreamController<String> _aiMessageController =
      StreamController<String>.broadcast();
  Stream<String> get aiMessages => _aiMessageController.stream;

  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSpeaking = ValueNotifier<bool>(false);

  // Connect to LiveKit room
  Future<void> connect({
    required String url,
    required String token,
    required String userName,
    required String agentName,
  }) async {
    try {
      _room = Room();

      // Set up room event listeners
      _room!.createListener()
        ..on<TrackSubscribedEvent>((event) {
          // Handle new track subscriptions (audio from AI)
          if (event.participant.identity == agentName) {
            _aiAgent = event.participant;
          }
        })
        ..on<ParticipantConnectedEvent>((event) {
          // AI agent has connected
          if (event.participant.identity == agentName) {
            _aiAgent = event.participant;
          }
        })
        ..on<DataReceivedEvent>((event) {
          // Handle text messages from AI
          if (event.participant?.identity == agentName) {
            final String message = String.fromCharCodes(event.data);
            _aiMessageController.add(message);
          }
        });

      // Connect to the room
      await _room!.connect(url, token);
      _localParticipant = _room!.localParticipant;
      isConnected.value = true;
    } catch (error) {
      print('LiveKit connection error: $error');
      rethrow;
    }
  }

  // Send voice to AI agent
  Future<void> enableMicrophone() async {
    if (_localParticipant != null) {
      final audioTrack = await LocalAudioTrack.create();
      await _localParticipant!.publishAudioTrack(audioTrack);
      isSpeaking.value = true;
    }
  }

  // Stop sending voice
  Future<void> disableMicrophone() async {
    if (_localParticipant != null) {
      await _localParticipant!.unpublishAllTracks();
      isSpeaking.value = false;
    }
  }

  // Send text message to AI
  Future<void> sendTextMessage(String message) async {
    if (_room != null && _aiAgent != null) {
      await _room!.localParticipant!.publishData(
        message.codeUnits,
        reliable: true,
        destinationIdentities: [_aiAgent!.sid],
      );
    }
  }

  // Disconnect from the room
  Future<void> disconnect() async {
    if (_room != null) {
      await _room!.disconnect();
      _room = null;
      _localParticipant = null;
      _aiAgent = null;
      isConnected.value = false;
      isSpeaking.value = false;
    }
  }

  void dispose() {
    _aiMessageController.close();
  }
}
