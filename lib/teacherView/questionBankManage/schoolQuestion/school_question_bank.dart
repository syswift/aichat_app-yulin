import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class QuestionBankItem {
  final String id;
  final String title;
  final String grade;
  final int questionCount;
  final String subject;

  QuestionBankItem({
    required this.id,
    required this.title,
    required this.grade,
    required this.questionCount,
    required this.subject,
  });
}

class SchoolQuestionBankPage extends StatefulWidget {
  final bool isSelectMode;
  final Function(List<QuestionBankItem>)? onConfirm;

  const SchoolQuestionBankPage({
    super.key,
    this.isSelectMode = false,
    this.onConfirm,
  });

  @override
  State<SchoolQuestionBankPage> createState() => _SchoolQuestionBankPageState();
}

class _SchoolQuestionBankPageState extends State<SchoolQuestionBankPage> {
  bool _isSelectMode = false;
  String _selectedGrade = '全部年级';
  
  // 模拟题库数据
  final List<QuestionBankItem> _allQuestionBanks = [
    QuestionBankItem(
      id: '1',
      title: '语文题库 1',
      grade: '一年级上册',
      questionCount: 120,
      subject: '语文',
    ),
    QuestionBankItem(
      id: '2',
      title: '数学题库 1',
      grade: '一年级上册',
      questionCount: 150,
      subject: '数学',
    ),
  ];

  late List<bool> _selectedItems;
  late List<QuestionBankItem> _filteredQuestionBanks;

  @override
  void initState() {
    super.initState();
    _isSelectMode = widget.isSelectMode;
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
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      // 删除 appBar
      floatingActionButton: widget.isSelectMode
          ? FloatingActionButton.extended(
              onPressed: () {
                final selectedBanks = <QuestionBankItem>[];
                for (int i = 0; i < _filteredQuestionBanks.length; i++) {
                  if (_selectedItems[i]) {
                    selectedBanks.add(_filteredQuestionBanks[i]);
                  }
                }
                if (selectedBanks.isNotEmpty) {
                  Navigator.pop(context, selectedBanks);
                }
              },
              backgroundColor: const Color(0xFFFFE4C4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                side: const BorderSide(
                  color: Color(0xFFDEB887),
                  width: 1,
                ),
              ),
              label: Text(
                '确认选择',
                style: TextStyle(
                  color: const Color(0xFF8B4513),
                  fontSize: ResponsiveSize.sp(22),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,

      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // 年级选择和下载按钮
                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 年级选择按钮
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
                            vertical: ResponsiveSize.h(12)
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
                      // 右侧按钮
                      if (!widget.isSelectMode)
                        Row(
                          children: [
                            if (_isSelectMode) ...[
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: 实现下载功能
                                },
                                icon: Icon(
                                  Icons.download,
                                  size: ResponsiveSize.w(24),
                                ),
                                label: Text(
                                  '下载选中题库',
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
                            ],
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
                                _isSelectMode ? Icons.close : Icons.download,
                                size: ResponsiveSize.w(24),
                              ),
                              label: Text(
                                _isSelectMode ? '取消' : '下载题库',
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
                          GestureDetector(
                            onTap: widget.isSelectMode ? () {
                              setState(() {
                                _selectedItems[index] = !_selectedItems[index];
                              });
                            } : null,
                            child: _buildQuestionBankCard(questionBank),
                          ),
                          if (widget.isSelectMode || _isSelectMode)
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
      ),
    );
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
                      color: const Color(0xFF8B4513),
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