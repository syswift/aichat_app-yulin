import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../singleQuestion/single_question.dart';
import 'select_question_page.dart';

class CreateQuestionBank extends StatefulWidget {
  const CreateQuestionBank({super.key});

  @override
  State<CreateQuestionBank> createState() => _CreateQuestionBankState();
}

class _CreateQuestionBankState extends State<CreateQuestionBank> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _durationController = TextEditingController();
  
  String? _selectedGrade;
  double _totalScore = 0;
  int _questionCount = 0;
  
  final List<QuestionItem?> _questions = [null];
  final List<TextEditingController> _scoreControllers = [TextEditingController()];

  final List<String> _grades = [
    '一年级上册',
    '一年级下册',
    '二年级上册',
    '二年级下册',
    '三年级上册',
    '三年级下册',
  ];

  @override
  void initState() {
    super.initState();
    _scoreControllers[0].addListener(_updateTotalScore);
    _updateQuestionCount();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _durationController.dispose();
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 方法保持不变...
  void _updateTotalScore() {
    double total = 0;
    for (var controller in _scoreControllers) {
      if (controller.text.isNotEmpty) {
        total += double.parse(controller.text);
      }
    }
    setState(() {
      _totalScore = total;
    });
  }

  void _addQuestionSlot() {
    setState(() {
      _questions.add(null);
      _scoreControllers.add(TextEditingController()
        ..addListener(_updateTotalScore));
      _updateQuestionCount();
    });
  }

  void _updateQuestionCount() {
    setState(() {
      _questionCount = _questions.where((q) => q != null).length;
    });
  }

  void _removeQuestionSlot(int index) {
    if (_questions.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('至少需要保留一道题目'),
          backgroundColor: Color(0xFF8B4513),
        ),
      );
      return;
    }
    
    setState(() {
      _questions.removeAt(index);
      _scoreControllers[index].dispose();
      _scoreControllers.removeAt(index);
      _updateTotalScore();
      _updateQuestionCount();
    });
  }

  Future<void> _addQuestion(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectQuestionsPage(),
      ),
    );

    if (result != null && result is List<QuestionItem>) {
      setState(() {
        _questions.removeAt(index);
        _scoreControllers[index].dispose();
        _scoreControllers.removeAt(index);
        
        for (var question in result) {
          _questions.add(question);
          _scoreControllers.add(TextEditingController()
            ..addListener(_updateTotalScore));
        }
        
        _updateQuestionCount();
      });
    }
  }

  void _createQuestionBank() {
    if (_formKey.currentState!.validate()) {
      if (_questions.where((q) => q != null).isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请至少添加一道题目'),
            backgroundColor: Color(0xFF8B4513),
          ),
        );
        return;
      }

      Navigator.pop(context, {
        'name': _nameController.text,
        'grade': _selectedGrade,
        'duration': int.parse(_durationController.text),
        'totalScore': _totalScore,
        'questionCount': _questionCount,
        'questions': _questions.where((q) => q != null).toList(),
      });
    }
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onPressed: _createQuestionBank,
                  icon: Icon(Icons.check, size: ResponsiveSize.w(24)),
                  label: Text(
                    '创建',
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
                        Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _nameController,
                            style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                            decoration: InputDecoration(
                              labelText: '题库名称',
                              labelStyle: TextStyle(
                                color: const Color(0xFF8B4513),
                                fontSize: ResponsiveSize.sp(20),
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
                              contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入题库名称';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGrade,
                            decoration: InputDecoration(
                              labelText: '适用年级',
                              labelStyle: TextStyle(
                                color: const Color(0xFF8B4513),
                                fontSize: ResponsiveSize.sp(20),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                borderSide: const BorderSide(color: Color(0xFFDEB887)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                            ),
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: const Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            items: _grades.map((grade) {
                              return DropdownMenuItem<String>(
                                value: grade,
                                child: Text(
                                  grade,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(20),
                                    color: const Color(0xFF8B4513),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGrade = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return '请选择年级';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                        Expanded(
                          child: TextFormField(
                            controller: _durationController,
                            style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                            decoration: InputDecoration(
                              labelText: '总时长(分钟)',
                              labelStyle: TextStyle(
                                color: const Color(0xFF8B4513),
                                fontSize: ResponsiveSize.sp(20),
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
                              contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入时长';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                                        SizedBox(height: ResponsiveSize.h(16)),
                    TextFormField(
                      controller: _noteController,
                      style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                      decoration: InputDecoration(
                        labelText: '备注',
                        labelStyle: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: ResponsiveSize.sp(20),
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
                        contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),

                    // 统计信息行
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveSize.w(16)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDEB887)),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                            ),
                            child: Text(
                              '总分：$_totalScore',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: const Color(0xFF8B4513),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveSize.w(16)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDEB887)),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                            ),
                            child: Text(
                              '题目数：$_questionCount',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: const Color(0xFF8B4513),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),
                                        // 题目列表区域
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          border: Border.all(color: const Color(0xFFDEB887)),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(ResponsiveSize.w(16)),
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
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
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}.',
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(20),
                                        color: const Color(0xFF8B4513),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveSize.w(16)),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => _addQuestion(index),
                                        child: _questions[index] == null
                                            ? Container(
                                                height: ResponsiveSize.h(100),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFDF5E6),
                                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                                  border: Border.all(color: const Color(0xFFDEB887)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '点击添加题目',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(18),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                _questions[index]!.title,
                                                style: TextStyle(
                                                  fontSize: ResponsiveSize.sp(18),
                                                  color: const Color(0xFF8B4513),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveSize.w(16)),
                                    SizedBox(
                                      width: ResponsiveSize.w(100),
                                      child: TextFormField(
                                        controller: _scoreControllers[index],
                                        style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                                        decoration: InputDecoration(
                                          labelText: '分值',
                                          labelStyle: TextStyle(
                                            color: const Color(0xFF8B4513),
                                            fontSize: ResponsiveSize.sp(20),
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
                                          contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => _updateTotalScore(),
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveSize.w(16)),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: const Color(0xFF8B4513),
                                        size: ResponsiveSize.w(24),
                                      ),
                                      onPressed: () => _removeQuestionSlot(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestionSlot,
        backgroundColor: const Color(0xFFFFE4C4),
        foregroundColor: const Color(0xFF8B4513),
        child: Icon(Icons.add, size: ResponsiveSize.w(24)),
      ),
    );
  }
}