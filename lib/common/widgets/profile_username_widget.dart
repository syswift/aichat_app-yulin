import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/responsive_size.dart';

class ProfileUsernameWidget extends StatefulWidget {
  final TextStyle? style;
  final Widget? loadingWidget;
  final String fallbackText;

  const ProfileUsernameWidget({
    Key? key,
    this.style,
    this.loadingWidget,
    this.fallbackText = "未知用户",
  }) : super(key: key);

  @override
  State<ProfileUsernameWidget> createState() => _ProfileUsernameWidgetState();
}

class _ProfileUsernameWidgetState extends State<ProfileUsernameWidget> {
  bool _isLoading = true;
  String _username = "";
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Get the current authenticated user
      final User? user = supabase.auth.currentUser;

      if (user != null) {
        // Fetch the user's profile from the profiles table
        final response =
            await supabase
                .from('profiles')
                .select('username')
                .eq('id', user.id)
                .single();

        setState(() {
          _username = response['username'] ?? widget.fallbackText;
          _isLoading = false;
        });
      } else {
        setState(() {
          _username = "未登录";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _username = "获取失败";
        _isLoading = false;
      });
      debugPrint('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default style if none provided
    final TextStyle defaultStyle = TextStyle(
      color: const Color(0xFF2B4C80),
      fontSize: ResponsiveSize.sp(20),
      fontWeight: FontWeight.bold,
    );

    // Default loading widget if none provided
    final Widget defaultLoadingWidget = SizedBox(
      width: ResponsiveSize.w(20),
      height: ResponsiveSize.h(20),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );

    if (_isLoading) {
      return widget.loadingWidget ?? defaultLoadingWidget;
    }

    return Text(_username, style: widget.style ?? defaultStyle);
  }
}
