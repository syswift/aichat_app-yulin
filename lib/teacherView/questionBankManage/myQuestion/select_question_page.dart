import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../singleQuestion/single_question.dart';

class SelectQuestionsPage extends StatefulWidget {
  const SelectQuestionsPage({super.key});

  @override
  State<SelectQuestionsPage> createState() => _SelectQuestionsPageState();
}

class _SelectQuestionsPageState extends State<SelectQuestionsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGrade;
  String? _selectedType;
  String? _selectedCategory;
  List<bool> _selectedItems = [];
  List<QuestionItem> _selectedQuestions = [];
  final List<QuestionItem> _allQuestions = SingleQuestionPage.allQuestions;
  List<QuestionItem> _filteredQuestions = [];

  final List<String> _grades = [
    '全部年级',
    '一年级上册',
    '一年级下册',
    '二年级上册',
    '二年级下册',
    '三年级上册',
    '三年级下册',
  ];

  final List<String> _types = [
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
    _filteredQuestions = List.from(_allQuestions);
    _selectedItems = List.generate(_allQuestions.length, (index) => false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterQuestions() {
    setState(() {
      _filteredQuestions = _allQuestions.where((question) {
        bool matchesGrade = _selectedGrade == null || 
                          _selectedGrade == '全部年级' || 
                          question.grade == _selectedGrade;
        bool matchesType = _selectedType == null || 
                          _selectedType == '全部类型' || 
                          question.type == _selectedType;
        bool matchesCategory = _selectedCategory == null || 
                             _selectedCategory == '全部种类' || 
                             question.category == _selectedCategory;
        bool matchesSearch = _searchController.text.isEmpty ||
                           question.title.toLowerCase()
                               .contains(_searchController.text.toLowerCase());
        
        return matchesGrade && matchesType && matchesCategory && matchesSearch;
      }).toList();
      
      _selectedItems = List.generate(_filteredQuestions.length, (index) => false);
    });
  }

  void _confirmSelection() {
    _selectedQuestions = [];
    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        _selectedQuestions.add(_filteredQuestions[i]);
      }
    }
    Navigator.pop(context, _selectedQuestions);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          children: [
            // 顶部栏
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/backbutton1.png',
                    width: ResponsiveSize.w(80),
                    height: ResponsiveSize.h(80),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _confirmSelection,
                  icon: Icon(Icons.check, size: ResponsiveSize.w(24)),
                  label: Text(
                    '添加',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    foregroundColor: const Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(24),
                      vertical: ResponsiveSize.h(16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      side: const BorderSide(
                        color: Color(0xFFDEB887),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(20)),

            // 筛选区域
            Row(
              children: [
                // 搜索框
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                    decoration: InputDecoration(
                      hintText: '搜索题目',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF8B4513),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        borderSide: const BorderSide(color: Color(0xFFDEB887)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        borderSide: const BorderSide(color: Color(0xFF8B4513)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => _filterQuestions(),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),

                // 年级选择
                Expanded(
                  child: _buildDropdown(
                    value: _selectedGrade,
                    items: _grades,
                    hint: '选择年级',
                    onChanged: (value) {
                      setState(() {
                        _selectedGrade = value;
                        _filterQuestions();
                      });
                    },
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),

                // 题型选择
                Expanded(
                  child: _buildDropdown(
                    value: _selectedType,
                    items: _types,
                    hint: '选择题型',
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                        _filterQuestions();
                      });
                    },
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),

                // 种类选择
                Expanded(
                  child: _buildDropdown(
                    value: _selectedCategory,
                    items: _categories,
                    hint: '选择种类',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _filterQuestions();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(20)),

            // 题目列表
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveSize.w(16)),
                  itemCount: _filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = _filteredQuestions[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        side: const BorderSide(
                          color: Color(0xFFDEB887),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                      child: CheckboxListTile(
                        value: _selectedItems[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedItems[index] = value ?? false;
                          });
                        },
                        title: Text(
                          question.title,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                        subtitle: Text(
                          '${question.grade} | ${question.type} | ${question.category}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(14),
                            color: Colors.grey[600],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF8B4513),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          borderSide: const BorderSide(color: Color(0xFFDEB887)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          borderSide: const BorderSide(color: Color(0xFF8B4513)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(19),
        ),
        isDense: true,
      ),
      style: TextStyle(
        fontSize: ResponsiveSize.sp(20),
        color: const Color(0xFF8B4513),
      ),
      hint: Center(
        child: Text(
          hint,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: const Color(0xFF8B4513),
          ),
        ),
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: const Color(0xFF8B4513),
        size: ResponsiveSize.w(28),
      ),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              color: const Color(0xFF8B4513),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}