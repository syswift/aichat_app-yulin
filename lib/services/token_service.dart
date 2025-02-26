import 'package:http/http.dart' as http;

class TokenService {
  static const String _tokenEndpoint = 'http://198.13.49.35:5050/getToken';

  /// 从API获取LiveKit令牌
  ///
  /// 可选地传递房间名称和用户身份
  /// 如果成功，返回令牌字符串；如果失败，返回null
  static Future<String?> getLiveKitToken({
    String? room,
    String? identity,
  }) async {
    try {
      // 构建请求URL，可能添加查询参数
      var uri = Uri.parse(_tokenEndpoint);

      // 如果提供了room或identity参数，添加到URL查询参数
      if (room != null || identity != null) {
        final queryParams = <String, String>{};
        if (room != null) queryParams['room'] = room;
        if (identity != null) queryParams['identity'] = identity;
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // API直接返回JWT字符串，无需JSON解析
        return response.body;
      } else {
        print('获取令牌失败: HTTP状态 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('获取令牌时发生错误: $e');
      return null;
    }
  }
}
