import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import './quick_review_page.dart';
import 'models/review_content_model.dart';
import 'package:just_audio/just_audio.dart';

class ReviewContentPage extends StatefulWidget {
  final ReviewItem reviewItem;

  const ReviewContentPage({
    super.key,
    required this.reviewItem,
  });

  @override
  State<ReviewContentPage> createState() => _ReviewContentPageState();
}

class _ReviewContentPageState extends State<ReviewContentPage> {
  bool _isVoicePlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  ReviewContentModel? _reviewContent;
  bool _isLoading = true;
  static const Color primaryColor = Color(0xFFFF9E9E);
  static const Color bgColor = Color(0xFFFFF7E6);
  static const Color textColor = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _loadReviewContent();
    _audioPlayer.setLoopMode(LoopMode.off);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadReviewContent() async {
    try {
      setState(() => _isLoading = true);
      // TODO: 从后端获取点评内容
      // final response = await ApiService.getReviewContent(widget.reviewItem.id);
      // final reviewContent = ReviewContentModel.fromJson(response.data);
      
      // 模拟数据
      await Future.delayed(const Duration(seconds: 1));
      final reviewContent = ReviewContentModel(
        aiReview: '这篇作业整体表现不错，语言生动形象，能够很好地描述场景和人物。建议在细节描写上可以再加强，让故事更加丰富生动。继续保持，相信会写出更好的作品！',
        manualReview: '同学写得很认真，故事情节完整，想象力丰富。建议可以多注意标点符号的使用，让文章更加通顺。继续加油！',
        voiceReviewUrl: 'assets/test_audio.mp3',
        score: 95,
        homeworkContent: '从前，在一个宁静的小镇上，住着一只可爱的小狗。它有着蓬松的毛发和一双明亮的大眼睛。每天早晨，它都会沿着小路散步，和遇到的每一个人打招呼。\n\n一天，它遇到了一只迷路的小猫。小狗决定帮助小猫找到回家的路。它们一起经历了许多有趣的冒险，最终不仅找到了小猫的家，还成为了最好的朋友。\n\n从那以后，小镇上经常能看到一只狗和一只猫形影不离地玩耍，它们的友谊感动了所有人。',
        homeworkImageUrl: 'assets/cartoon.png',  // 使用本地图片
      );

      if (mounted) {
        setState(() {
          _reviewContent = reviewContent;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // TODO: 显示错误提示
      }
    }
  }

  Future<void> _playVoiceReview() async {
    if (_reviewContent?.voiceReviewUrl == null) return;
    
    try {
      if (_isVoicePlaying) {
        await _audioPlayer.pause();
        setState(() => _isVoicePlaying = false);
      } else {
        await _audioPlayer.setAsset(_reviewContent!.voiceReviewUrl);
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() => _isVoicePlaying = false);
          }
        });
        await _audioPlayer.play();
        setState(() => _isVoicePlaying = true);
      }
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('音频播放失败：$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 自定义标题栏
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,  // 状态栏高度
              left: ResponsiveSize.w(16),
              right: ResponsiveSize.w(16),
            ),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/backbutton1.png',
                    width: ResponsiveSize.w(60),
                    height: ResponsiveSize.h(60),
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '点评详情',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                // 为了保持标题居中，添加一个占位
                SizedBox(width: ResponsiveSize.w(60)),
              ],
            ),
          ),
          // 原有的内容部分
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color(0xFFFFF7E6).withOpacity(0.3),
                  ],
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // 左侧点评内容
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(24),
                          vertical: ResponsiveSize.h(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoCard(),
                              SizedBox(height: ResponsiveSize.h(24)),
                              _buildScoreCard(),
                              SizedBox(height: ResponsiveSize.h(24)),
                              _buildReviewsSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 右侧作业内容
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ResponsiveSize.w(24)),
                            bottomLeft: Radius.circular(ResponsiveSize.w(24)),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: ResponsiveSize.w(10),
                              offset: Offset(-4, 0),
                            ),
                          ],
                        ),
                        child: _buildHomeworkContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            label: '学员',
            value: widget.reviewItem.student,
          ),
          Divider(height: ResponsiveSize.h(24)),
          _buildInfoRow(
            icon: Icons.assignment_outlined,
            label: '任务',
            value: widget.reviewItem.task,
          ),
          Divider(height: ResponsiveSize.h(24)),
          _buildInfoRow(
            icon: Icons.access_time,
            label: '提交时间',
            value: widget.reviewItem.uploadTime,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: ResponsiveSize.w(20), color: primaryColor),
        SizedBox(width: ResponsiveSize.w(8)),
        Text(
          '$label：',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '综合评分',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${_reviewContent?.score ?? 0}',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(48),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                ' / 100',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '点评内容',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          if (_reviewContent?.hasAiReview ?? false)
            _buildReviewItem(
              icon: Icons.smart_toy_outlined,
              title: 'AI点评',
              content: _reviewContent!.aiReview,
            ),
          if (_reviewContent?.hasManualReview ?? false) ...[
            SizedBox(height: ResponsiveSize.h(16)),
            _buildReviewItem(
              icon: Icons.edit_outlined,
              title: '普通点评',
              content: _reviewContent!.manualReview,
            ),
          ],
          if (_reviewContent?.hasVoiceReview ?? false) ...[
            SizedBox(height: ResponsiveSize.h(16)),
            _buildVoiceReviewItem(),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: ResponsiveSize.w(20), color: primaryColor),
              SizedBox(width: ResponsiveSize.w(8)),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(12)),
          Text(
            content,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceReviewItem() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.mic_none_outlined, size: ResponsiveSize.w(20), color: primaryColor),
          SizedBox(width: ResponsiveSize.w(8)),
          Text(
            '语音点评',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              _isVoicePlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
              color: primaryColor,
              size: ResponsiveSize.w(28),
            ),
            onPressed: _playVoiceReview,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      height: double.infinity,  // 占据全部高度
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '作业内容',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(20),
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveSize.w(16)),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_reviewContent?.hasHomeworkImage ?? false) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Image.asset(
                            _reviewContent!.homeworkImageUrl,
                            width: constraints.maxWidth,  // 使用容器的最大宽度
                            fit: BoxFit.contain,  // 使用 contain 保持原始比例
                          );
                        },
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),
                  ],
                  Text(
                    _reviewContent?.homeworkContent ?? '',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: textColor.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 