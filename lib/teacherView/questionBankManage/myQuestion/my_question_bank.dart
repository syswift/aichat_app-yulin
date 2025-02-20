import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'create_question_bank.dart';

class QuestionBankItem {
  final String title;
  final String grade;
  final int questionCount;
  final String subject;
  final DateTime createTime;

  QuestionBankItem({
    required this.title,
    required this.grade,
    required this.questionCount,
    required this.subject,
    required this.createTime,
  });
}

class MyQuestionBankPage extends StatefulWidget {
  const MyQuestionBankPage({super.key});

  @override
  State<MyQuestionBankPage> createState() => _MyQuestionBankPageState();
}

class _MyQuestionBankPageState extends State<MyQuestionBankPage> {
  bool _isSelectMode = false;
  String _selectedGrade = '全部年级';
  
  // 模拟题库数据
  final List<QuestionBankItem> _allQuestionBanks = [
    QuestionBankItem(
      title: '我的语文题库 1',
      grade: '一年级上册',
      questionCount: 50,
      subject: '语文',
      createTime: DateTime.now(),
    ),
    QuestionBankItem(
      title: '我的数学题库 1',
      grade: '一年级上册',
      questionCount: 80,
      subject: '数学',
      createTime: DateTime.now(),
    ),
  ];

  late List<bool> _selectedItems;
  late List<QuestionBankItem> _filteredQuestionBanks;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.generate(_allQuestionBanks.length, (index) => false);
    _filteredQuestionBanks = List.from(_allQuestionBanks);
  }

  void _filterQuestionBanks(String grade) {
    setState(() {
      _selectedGrade = grade;
      if (grade == '全部年级') {
        _filteredQuestionBanks = List.from(_allQuestionBanks);
      } else {
        _filteredQuestionBanks = _allQuestionBanks
            .where((bank) => bank.grade.contains(grade))
            .toList();
      }
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

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              // 操作按钮栏
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 左侧年级选择
                    PopupMenuButton<String>(
                      onSelected: _filterQuestionBanks,
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
                        const PopupMenuDivider(height: 1),
                        _buildPopupMenuItem('一年级'),
                        const PopupMenuDivider(height: 1),
                        _buildPopupMenuItem('二年级'),
                        const PopupMenuDivider(height: 1),
                        _buildPopupMenuItem('三年级'),
                      ],
                    ),
                    // 右侧按钮组
                    Row(
                      children: [
                        // 上传按钮
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: 实现上传功能
                          },
                          icon: Icon(
                            Icons.upload,
                            size: ResponsiveSize.w(24),
                          ),
                          label: Text(
                            '上传',
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
                        // 创建按钮
                        ElevatedButton.icon(
                          onPressed: () => _handleCreateQuestionBank(context),
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
              // 题库网格列表
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: ResponsiveSize.w(20),
                    mainAxisSpacing: ResponsiveSize.h(20),
                  ),
                  itemCount: _filteredQuestionBanks.length,
                  itemBuilder: (context, index) {
                    final questionBank = _filteredQuestionBanks[index];
                    return Stack(
                      children: [
                        _buildQuestionBankCard(questionBank),
                        if (_isSelectMode)
                          Positioned(
                            top: ResponsiveSize.h(8),
                            right: ResponsiveSize.w(8),
                            child: Checkbox(
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
                            ),
                          ),
                      ],
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

  Future<void> _handleCreateQuestionBank(BuildContext context) async {
    if (!mounted) return;
    
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final result = await navigator.push<dynamic>(
        MaterialPageRoute(
          builder: (BuildContext context) => const CreateQuestionBank(),
        ),
      );

      if (!mounted) return;

      if (result != null) {
        if (result is QuestionBankItem) {
          setState(() {
            _allQuestionBanks.add(result);
            _selectedItems.add(false);
            _filterQuestionBanks(_selectedGrade);
          });
        } else if (result is Map<String, dynamic>) {
          final newQuestionBank = QuestionBankItem(
            title: (result['title'] as String?) ?? '未命名题库',
            grade: (result['grade'] as String?) ?? '未分类',
            questionCount: (result['questionCount'] as int?) ?? 0,
            subject: (result['subject'] as String?) ?? '未知科目',
            createTime: (result['createTime'] as DateTime?) ?? DateTime.now(),
          );

          setState(() {
            _allQuestionBanks.add(newQuestionBank);
            _selectedItems.add(false);
            _filterQuestionBanks(_selectedGrade);
          });
        }

        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                '题库创建成功',
                style: TextStyle(fontSize: ResponsiveSize.sp(16)),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              '创建题库失败: ${e.toString()}',
              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error creating question bank: $e');
    }
  }

  Widget _buildQuestionBankCard(QuestionBankItem questionBank) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(8),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题库封面
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(12)),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/question_bank.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 题库信息
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionBank.title,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.h(4)),
                  Text(
                    questionBank.grade,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(4)),
                  Text(
                    '共 ${questionBank.questionCount} 道题',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}