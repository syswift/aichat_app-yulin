import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/responsive_size.dart';
import 'create_single_question.dart';

class QuestionItem {
  final String title;
  final String grade;
  final String type;
  final DateTime createTime;
  final String description;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;
  final String category;

  QuestionItem({
    required this.title,
    required this.grade,
    required this.type,
    required this.createTime,
    required this.description,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    required this.category,
  });
}

class SingleQuestionPage extends StatefulWidget {
  const SingleQuestionPage({super.key});
  
  static List<QuestionItem> get allQuestions => _SingleQuestionPageState._allQuestions;

  @override
  State<SingleQuestionPage> createState() => _SingleQuestionPageState();
}

class _SingleQuestionPageState extends State<SingleQuestionPage> {
  bool _isSelectMode = false;
  String _selectedGrade = '全部年级';
  String _selectedType = '全部类型';
  String _selectedCategory = '全部种类';
    static final List<QuestionItem> _allQuestions = [
    QuestionItem(
      title: '基础加法运算',
      grade: '一年级上册',
      type: '单选题',
      createTime: DateTime.now().subtract(const Duration(days: 1)),
      description: '1 + 1 = ?',
      category: '阅读',
    ),
    QuestionItem(
      title: '地球知识判断',
      grade: '一年级上册',
      type: '判断题',
      createTime: DateTime.now().subtract(const Duration(days: 2)),
      description: '判断对错：地球是圆的',
      category: '阅读',
    ),
    QuestionItem(
      title: '识字练习：春天',
      grade: '一年级上册',
      type: '看图识字',
      createTime: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'assets/cartoon.png',
      description: '请看图识字：春、花、草、树',
      category: '阅读',
    ),
    QuestionItem(
      title: '英语单词听力',
      grade: '二年级上册',
      type: '音频题',
      createTime: DateTime.now().subtract(const Duration(days: 4)),
      audioUrl: 'assets/test_audio.mp3',
      description: '听音选择正确的单词',
      category: '听力',
    ),
    QuestionItem(
      title: '自然现象观察',
      grade: '二年级上册',
      type: '视频题',
      createTime: DateTime.now().subtract(const Duration(days: 5)),
      videoUrl: 'assets/test_video.mp4',
      description: '观看视频后回答问题：雨是怎么形成的？',
      category: '阅读',
    ),
    QuestionItem(
      title: '水果种类选择',
      grade: '一年级上册',
      type: '多选题',
      createTime: DateTime.now().subtract(const Duration(days: 6)),
      description: '以下哪些是夏季水果？',
      category: '书写',
    ),
  ];

  late List<bool> _selectedItems;
  late List<QuestionItem> _filteredQuestions;

  final List<String> _questionTypes = [
    '全部类型',
    '单选题',
    '判断题',
    '多选题',
    '音频题',
    '看图识字',
    '视频题',
  ];
  
  final List<String> _categories = [
    '全部种类',
    '听力',
    '口语',
    '阅读',
    '书写',
  ];

  @override
  void initState() {
    super.initState();
    _selectedItems = List.generate(_allQuestions.length, (index) => false);
    _filteredQuestions = List.from(_allQuestions);
  }

  void _filterQuestions() {
    setState(() {
      _filteredQuestions = _allQuestions.where((question) {
        bool gradeMatch = _selectedGrade == '全部年级' || 
                         question.grade.contains(_selectedGrade);
        bool typeMatch = _selectedType == '全部类型' || 
                        question.type == _selectedType;
        bool categoryMatch = _selectedCategory == '全部种类' ||
                           question.category == _selectedCategory;
        return gradeMatch && typeMatch && categoryMatch;
      }).toList();
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      height: ResponsiveSize.h(48),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: const Color(0xFF8B4513),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  IconData _getQuestionTypeIcon(String type) {
    switch (type) {
      case '单选题':
        return Icons.radio_button_checked;
      case '判断题':
        return Icons.check_circle_outline;
      case '多选题':
        return Icons.check_box;
      case '音频题':
        return Icons.audiotrack;
      case '看图识字':
        return Icons.image;
      case '视频题':
        return Icons.video_library;
      default:
        return Icons.question_answer;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (grade) {
                            setState(() {
                              _selectedGrade = grade;
                              _filterQuestions();
                            });
                          },
                          offset: Offset(0, ResponsiveSize.h(60)),
                          constraints: BoxConstraints(
                            minWidth: ResponsiveSize.w(200),
                            maxWidth: ResponsiveSize.w(200),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: ResponsiveSize.w(200),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(20),
                              vertical: ResponsiveSize.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4C4),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              border: Border.all(
                                color: const Color(0xFFDEB887),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedGrade,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(8)),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFF8B4513),
                                  size: ResponsiveSize.w(28),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            _buildPopupMenuItem('全部年级'),
                            PopupMenuDivider(height: ResponsiveSize.h(1)),
                            _buildPopupMenuItem('一年级'),
                            PopupMenuDivider(height: ResponsiveSize.h(1)),
                            _buildPopupMenuItem('二年级'),
                            PopupMenuDivider(height: ResponsiveSize.h(1)),
                            _buildPopupMenuItem('三年级'),
                          ],
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                                                // 题型选择按钮
                        PopupMenuButton<String>(
                          onSelected: (type) {
                            setState(() {
                              _selectedType = type;
                              _filterQuestions();
                            });
                          },
                          offset: Offset(0, ResponsiveSize.h(60)),
                          constraints: BoxConstraints(
                            minWidth: ResponsiveSize.w(200),
                            maxWidth: ResponsiveSize.w(200),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: ResponsiveSize.w(200),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(20),
                              vertical: ResponsiveSize.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4C4),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              border: Border.all(
                                color: const Color(0xFFDEB887),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedType,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(8)),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFF8B4513),
                                  size: ResponsiveSize.w(28),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (BuildContext context) {
                            return _questionTypes.map((type) {
                              return PopupMenuItem<String>(
                                value: type,
                                child: _buildPopupMenuItem(type),
                              );
                            }).toList();
                          },
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),

                        // 种类选择按钮
                        PopupMenuButton<String>(
                          onSelected: (category) {
                            setState(() {
                              _selectedCategory = category;
                              _filterQuestions();
                            });
                          },
                          offset: Offset(0, ResponsiveSize.h(60)),
                          constraints: BoxConstraints(
                            minWidth: ResponsiveSize.w(200),
                            maxWidth: ResponsiveSize.w(200),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: ResponsiveSize.w(200),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(20),
                              vertical: ResponsiveSize.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4C4),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              border: Border.all(
                                color: const Color(0xFFDEB887),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedCategory,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(8)),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFF8B4513),
                                  size: ResponsiveSize.w(28),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (BuildContext context) {
                            return _categories.map((category) {
                              return PopupMenuItem<String>(
                                value: category,
                                child: _buildPopupMenuItem(category),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                                        // 右侧按钮组
                    Row(
                      children: [
                        // 创建按钮
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateSingleQuestionPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            size: ResponsiveSize.w(24),
                          ),
                          label: Text(
                            '创建',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(22),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE4C4),
                            foregroundColor: const Color(0xFF8B4513),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(40),
                              vertical: ResponsiveSize.h(12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              side: const BorderSide(
                                color: Color(0xFFDEB887),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                        // 删除按钮
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isSelectMode = !_isSelectMode;
                              if (!_isSelectMode) {
                                _selectedItems.fillRange(0, _selectedItems.length, false);
                              }
                            });
                          },
                          icon: Icon(
                            _isSelectMode ? Icons.close : Icons.delete,
                            size: ResponsiveSize.w(24),
                          ),
                          label: Text(
                            _isSelectMode ? '取消' : '删除',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(22),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE4C4),
                            foregroundColor: const Color(0xFF8B4513),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(40),
                              vertical: ResponsiveSize.h(12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              side: const BorderSide(
                                color: Color(0xFFDEB887),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                            // 习题列表
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  itemCount: _filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = _filteredQuestions[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                      ),
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 选择框或题型图标
                            SizedBox(
                              width: ResponsiveSize.w(40),
                              child: _isSelectMode
                                  ? Checkbox(
                                      value: _selectedItems[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _selectedItems[index] = value ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                      ),
                                      activeColor: const Color(0xFF8B4513),
                                    )
                                  : Icon(
                                      _getQuestionTypeIcon(question.type),
                                      color: const Color(0xFF8B4513),
                                      size: ResponsiveSize.w(32),
                                    ),
                            ),
                            SizedBox(width: ResponsiveSize.w(16)),
                            // 题目内容
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(18),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8B4513),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(8)),
                                  Text(
                                    question.description,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(16),
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(12)),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.w(12),
                                          vertical: ResponsiveSize.h(4),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE4C4),
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                                          border: Border.all(color: const Color(0xFFDEB887)),
                                        ),
                                        child: Text(
                                          question.grade,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(14),
                                            color: const Color(0xFF8B4513),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(12)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.w(12),
                                          vertical: ResponsiveSize.h(4),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE4C4),
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                                          border: Border.all(color: const Color(0xFFDEB887)),
                                        ),
                                        child: Text(
                                          question.type,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(14),
                                            color: const Color(0xFF8B4513),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(12)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.w(12),
                                          vertical: ResponsiveSize.h(4),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE4C4),
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                                          border: Border.all(color: const Color(0xFFDEB887)),
                                        ),
                                        child: Text(
                                          question.category,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(14),
                                            color: const Color(0xFF8B4513),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '创建时间：${_formatDate(question.createTime)}',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(14),
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (question.imageUrl != null ||
                                      question.audioUrl != null ||
                                      question.videoUrl != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: ResponsiveSize.h(12)),
                                      child: Row(
                                        children: [
                                          Icon(
                                            question.imageUrl != null
                                                ? Icons.image
                                                : question.audioUrl != null
                                                    ? Icons.audiotrack
                                                    : Icons.video_library,
                                            size: ResponsiveSize.w(20),
                                            color: const Color(0xFF8B4513),
                                          ),
                                          SizedBox(width: ResponsiveSize.w(8)),
                                          Text(
                                            question.imageUrl != null
                                                ? '包含图片'
                                                : question.audioUrl != null
                                                    ? '包含音频'
                                                    : '包含视频',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(14),
                                              color: const Color(0xFF8B4513),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}