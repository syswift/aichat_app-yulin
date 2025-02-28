// lib/services/background_service.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final _supabase = Supabase.instance.client;
  final String _storageBucket = 'background';
  String? _cachedBackgroundFileName;

  Future<ImageProvider> getBackgroundImage() async {
    try {
      // Use cached filename if available, otherwise fetch from database
      String backgroundFileName =
          _cachedBackgroundFileName ?? await _fetchBackgroundFileName();

      // If no background is set, use the default
      if (backgroundFileName.isEmpty) {
        return const AssetImage('assets/background.jpg');
      }

      // Get URL from Supabase storage
      final publicUrl = _supabase.storage
          .from(_storageBucket)
          .getPublicUrl(backgroundFileName);

      return NetworkImage(publicUrl);
    } catch (e) {
      debugPrint('Error loading background: $e');
      // Fallback to default if there's an error
      return const AssetImage('assets/background.jpg');
    }
  }

  Future<String> _fetchBackgroundFileName() async {
    try {
      final response =
          await _supabase
              .from('system_settings')
              .select('setting_value')
              .eq('setting_name', 'background')
              .single();

      final fileName = response['setting_value'] as String;
      // Cache the filename
      _cachedBackgroundFileName = fileName;
      debugPrint('Retrieved background filename: $fileName');
      return fileName;
    } catch (e) {
      debugPrint('Error fetching background setting: $e');
      return '';
    }
  }

  // Call this when background is changed to invalidate cache
  void clearCache() {
    _cachedBackgroundFileName = null;
  }
}
