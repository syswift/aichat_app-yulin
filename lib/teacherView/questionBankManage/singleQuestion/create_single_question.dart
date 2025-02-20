import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'single_question.dart';
import 'question_templates.dart';

class CreateSingleQuestionPage extends StatefulWidget {
  const CreateSingleQuestionPage({super.key});

  @override
  State<CreateSingleQuestionPage> createState() => _CreateSingleQuestionPageState();
}

class _CreateSingleQuestionPageState extends State<CreateSingleQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _contentController = TextEditingController();
  
  String? _selectedGrade;
  String? _selectedType;
  String? _selectedCategory;
  int _currentQuestionIndex = 1;
  bool _isSelecting = false;
  int? _selectedQuestionIndex;

  final List<String> _grades = [
    '一年级上册',
    '一年级下册',
    '二年级上册',
    '二年级下册',
    '三年级上册',
    '三年级下册',
  ];

  final List<String> _types = [
    '单选题',
    '判断题',
    '多选题',
    '音频题',
    '看图识字',
    '视频题',
  ];

  final List<String> _categories = [
    '听力',
    '口语',
    '阅读',
    '书写',
  ];
    @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _createQuestion() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGrade == null || 
          _selectedType == null || 
          _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请选择年级、题型和种类'),
            backgroundColor: Color(0xFF8B4513),
          ),
        );
        return;
      }
      
      final newQuestion = QuestionItem(
        title: _titleController.text,
        grade: _selectedGrade!,
        type: _selectedType!,
        createTime: DateTime.now(),
        description: _contentController.text,
        category: _selectedCategory!,
      );
      Navigator.pop(context, newQuestion);
    }
  }

  void _onTypeChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedType = value;
      _currentQuestionIndex = 1;
      _contentController.text = QuestionTemplate.getTemplate(value);
    });
  }

  void _addNewQuestion() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择题型'),
          backgroundColor: Color(0xFF8B4513),
        ),
      );
      return;
    }
    
    setState(() {
      _currentQuestionIndex++;
      _contentController.text = _contentController.text + 
          QuestionTemplate.getTemplate(_selectedType!, index: _currentQuestionIndex);
    });
  }

  void _deleteSelectedQuestion() {
    if (_selectedQuestionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择要删除的题目'),
          backgroundColor: Color(0xFF8B4513),
        ),
      );
      return;
    }

    List<String> questions = _contentController.text.split('----------------------------------------\n');
    if (_selectedQuestionIndex! < questions.length) {
      questions.removeAt(_selectedQuestionIndex!);
      
      String newContent = '';
      for (int i = 0; i < questions.length; i++) {
        String question = questions[i];
        if (i == 0) {
          newContent += question;
        } else {
          newContent += question.replaceFirst(
            RegExp(r'\d+\. '),
            '${i + 1}. ',
          );
        }
        if (i < questions.length - 1) {
          newContent += '----------------------------------------\n';
        }
      }
      
      setState(() {
        _contentController.text = newContent;
        _currentQuestionIndex--;
        _selectedQuestionIndex = null;
        _isSelecting = false;
      });
    }
  }

  void _addAttachment(String type) {
    // TODO: 实现附件添加逻辑
    print('添加$type');
  }

  Widget _buildActionButton(String label, String iconPath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: ResponsiveSize.w(32),
            height: ResponsiveSize.h(32),
          ),
          SizedBox(height: ResponsiveSize.h(4)),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF8B4513),
              fontSize: ResponsiveSize.sp(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
                  onPressed: _createQuestion,
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

            // 表单内容
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 习题名称
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                      decoration: InputDecoration(
                        labelText: '习题名称',
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
                          return '请输入习题名称';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),
                                        // 备注
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
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),

                    // 选择区域
                    Row(
                      children: [
                        // 适用年级
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
                            hint: Text(
                              '请选择年级',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: Colors.grey,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            menuMaxHeight: ResponsiveSize.h(200),
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: const Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请选择年级';
                              }
                              return null;
                            },
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
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(20)),
                                                // 题型
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedType,
                            decoration: InputDecoration(
                              labelText: '题型',
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
                            hint: Text(
                              '请选择题型',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: Colors.grey,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            menuMaxHeight: ResponsiveSize.h(200),
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: const Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请选择题型';
                              }
                              return null;
                            },
                            items: _types.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(20),
                                    color: const Color(0xFF8B4513),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: _onTypeChanged,
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(20)),

                        // 种类
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: '种类',
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
                            hint: Text(
                              '请选择种类',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: Colors.grey,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            menuMaxHeight: ResponsiveSize.h(200),
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: const Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请选择种类';
                              }
                              return null;
                            },
                            items: _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
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
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),
                                        // 习题内容区域
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          border: Border.all(color: const Color(0xFFDEB887)),
                        ),
                        child: Column(
                          children: [
                            // 固定在顶部的工具栏
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(24),
                                vertical: ResponsiveSize.h(12),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4C4),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(ResponsiveSize.w(8)),
                                  topRight: Radius.circular(ResponsiveSize.w(8)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildActionButton(
                                    '图片',
                                    'assets/image_icon.png',
                                    () => _addAttachment('图片'),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(40)),
                                  _buildActionButton(
                                    '音频',
                                    'assets/audio_icon.png',
                                    () => _addAttachment('音频'),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(40)),
                                  _buildActionButton(
                                    '视频',
                                    'assets/video_icon.png',
                                    () => _addAttachment('视频'),
                                  ),
                                  const Spacer(),
                                  // 添加题目按钮
                                  ElevatedButton.icon(
                                    onPressed: _addNewQuestion,
                                    icon: Icon(Icons.add, size: ResponsiveSize.w(20)),
                                    label: Text(
                                      '添加题目',
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFE4C4),
                                      foregroundColor: const Color(0xFF8B4513),
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.w(16),
                                        vertical: ResponsiveSize.h(8),
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
                                  SizedBox(width: ResponsiveSize.w(16)),
                                                                    // 删除题目按钮
                                  ElevatedButton.icon(
                                    onPressed: _deleteSelectedQuestion,
                                    icon: Icon(Icons.delete_outline, size: ResponsiveSize.w(20)),
                                    label: Text(
                                      '删除题目',
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFE4C4),
                                      foregroundColor: const Color(0xFF8B4513),
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.w(16),
                                        vertical: ResponsiveSize.h(8),
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
                            ),
                            // 可滚动的内容区域
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(ResponsiveSize.w(8)),
                                      bottomRight: Radius.circular(ResponsiveSize.w(8)),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTapDown: (details) {
                                      final text = _contentController.text;
                                      final offset = _contentController.selection.baseOffset;
                                      if (offset >= 0) {
                                        final beforeText = text.substring(0, offset);
                                        final questionIndex = beforeText.split('----------------------------------------\n').length - 1;
                                        setState(() {
                                          _selectedQuestionIndex = questionIndex;
                                          _isSelecting = true;
                                        });
                                      }
                                    },
                                    child: TextFormField(
                                      controller: _contentController,
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(20),
                                        backgroundColor: _isSelecting ? const Color(0xFFFFE4E1) : null,
                                      ),
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: '请输入习题内容...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: ResponsiveSize.sp(20),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入习题内容';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}