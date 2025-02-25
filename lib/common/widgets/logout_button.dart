import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../login/login_page.dart';
import 'dart:developer' as developer;

class LogoutButton extends StatelessWidget {
  final double size;

  const LogoutButton({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Image.asset('assets/quit.png', width: size, height: size),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                developer.log('正在退出登录...');
                try {
                  // Sign out from Supabase
                  await Supabase.instance.client.auth.signOut();
                  developer.log('退出登录成功');

                  // Navigate to login page and clear all previous routes
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  developer.log('退出登录失败: $e', error: e);
                  // You might want to show an error message to the user
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('退出登录失败: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('确认', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
