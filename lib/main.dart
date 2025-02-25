import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart'; // 添加相机导入
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'utils/responsive_size.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await availableCameras(); // 初始化相机
  } catch (e) {
    debugPrint('Error initializing cameras: $e');
  }

  // 强制横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '鹅爸爸登录',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: (context, child) {
        // 先获取 MediaQuery
        final mediaQuery = MediaQuery.of(context);

        // 创建新的 MediaQuery
        final newMediaQuery = mediaQuery.copyWith(
          textScaler: const TextScaler.linear(1.0),
        );

        // 使用新的 MediaQuery 初始化 ResponsiveSize
        return MediaQuery(
          data: newMediaQuery,
          child: Builder(
            builder: (context) {
              ResponsiveSize.init(context);
              return child!;
            },
          ),
        );
      },
      home: const LoginPage(),
    );
  }
}
