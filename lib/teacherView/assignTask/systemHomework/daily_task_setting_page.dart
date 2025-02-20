import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import './models/daily_task.dart';
import '../../questionBankManage/schoolQuestion/school_question_bank.dart';

class DailyTaskSettingPage extends StatefulWidget {
  final List<DailyTask> existingTasks;
  final Function(DailyTask) onTaskAdded;
  final DailyTask? taskToEdit;
  final Function(DailyTask)? onTaskEdited;

  const DailyTaskSettingPage({
    super.key,
    required this.existingTasks,
    required this.onTaskAdded,
    this.taskToEdit,
    this.onTaskEdited,
  });

  @override
  State<DailyTaskSettingPage> createState() => _DailyTaskSettingPageState();
}

class _DailyTaskSettingPageState extends State<DailyTaskSettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _taskNoteController = TextEditingController();
  final _taskCountController = TextEditingController();

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: ResponsiveSize.sp(16),
        color: const Color(0xFF5A2E17).withOpacity(0.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(12),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(color: Color(0xFFDEB887)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(color: Color(0xFFDEB887)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
    // 如果是编辑模式，填充表单和题库信息
    if (widget.taskToEdit != null) {
      _taskNameController.text = widget.taskToEdit!.taskName;
      _taskNoteController.text = widget.taskToEdit!.taskNote;
      _taskCountController.text = widget.taskToEdit!.taskCount.toString();
      
      // 如果是题库任务，添加题库信息到列表
      if (widget.taskToEdit!.isFromQuestionBank && 
          widget.taskToEdit!.questionBankInfo != null &&
          widget.taskToEdit!.questionBankInfo!['banks'] != null) {
        questionBankList = List<Map<String, dynamic>>.from(
          widget.taskToEdit!.questionBankInfo!['banks']
        );
      }
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final task = DailyTask(
        taskName: _taskNameController.text,
        taskNote: _taskNoteController.text,
        taskCount: int.parse(_taskCountController.text),
        isFromQuestionBank: questionBankList.isNotEmpty,
        questionBankId: questionBankList.isNotEmpty 
            ? questionBankList.map((bank) => bank['id'].toString()).toList()
            : null,
        questionBankInfo: {
          'banks': questionBankList,
          'totalQuestionCount': questionBankList.fold<int>(
            0, 
            (sum, bank) => sum + (bank['questionCount'] as int? ?? 0)
          ),
        },
      );
      
      if (widget.taskToEdit != null) {
        widget.onTaskEdited?.call(task);
      } else {
        widget.onTaskAdded(task);
      }
      Navigator.pop(context);
    }
  }

  void _importFromQuestionBank() async {
    final List<QuestionBankItem>? selectedBanks = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SchoolQuestionBankPage(
          isSelectMode: true,
        ),
      ),
    );

    if (selectedBanks != null && selectedBanks.isNotEmpty) {
      setState(() {
        for (var bank in selectedBanks) {
          questionBankList.add({
            'title': bank.title,
            'grade': bank.grade,
            'subject': bank.subject,
            'questionCount': bank.questionCount,
            'id': bank.id,
          });
        }
      });
    }
  }

  List<Map<String, dynamic>> questionBankList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1D6),
      body: Stack(
        children: [
          // 返回按钮
          Positioned(
            top: ResponsiveSize.h(40),
            left: ResponsiveSize.w(32),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/backbutton1.png',
                width: ResponsiveSize.w(80),
                height: ResponsiveSize.h(80),
              ),
            ),
          ),

          // 标题
          Positioned(
            top: ResponsiveSize.h(55),
            left: ResponsiveSize.w(140),
            child: Text(
              '设置每日任务',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
          ),

          // 主要内容 - 添加 SingleChildScrollView
          Padding(
            padding: EdgeInsets.only(top: ResponsiveSize.h(150)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveSize.w(32),
                  right: ResponsiveSize.w(32),
                  bottom: ResponsiveSize.h(32),
                ),
                child: Column(
                  children: [
                    // 如果有导入的题库，显示题库列表
                    if (questionBankList.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                          border: Border.all(color: const Color(0xFFDEB887)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '已导入题库',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(18),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF5A2E17),
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(12)),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: questionBankList.length,
                              itemBuilder: (context, index) {
                                final bank = questionBankList[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
                                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF1D6),
                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bank['title'] ?? '',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(16),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: ResponsiveSize.h(4)),
                                            Text(
                                              '${bank['grade'] ?? ''} ${bank['subject'] ?? ''}',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(14),
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '共${bank['questionCount'] ?? 0}道题',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(14),
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            questionBankList.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red[400],
                                          size: ResponsiveSize.w(24),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(16)),
                    ],

                    // 任务表单
                    Container(
                      padding: EdgeInsets.all(ResponsiveSize.w(32)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: ResponsiveSize.w(10),
                            offset: Offset(0, ResponsiveSize.h(4)),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _taskNameController,
                              decoration: _buildInputDecoration('任务名称'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入任务名称';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: ResponsiveSize.h(24)),
                            TextFormField(
                              controller: _taskNoteController,
                              decoration: _buildInputDecoration('任务备注'),
                              maxLines: 3,
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            // 将导入按钮靠左对齐
                            ElevatedButton.icon(
                              onPressed: _importFromQuestionBank,
                              icon: Icon(
                                Icons.library_books,
                                size: ResponsiveSize.w(24),
                              ),
                              label: Text(
                                '从题库导入',
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
                                  vertical: ResponsiveSize.h(16),
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
                            SizedBox(height: ResponsiveSize.h(24)),
                            TextFormField(
                              controller: _taskCountController,
                              decoration: _buildInputDecoration('每次任务数量'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入任务数量';
                                }
                                if (int.tryParse(value) == null) {
                                  return '请输入有效的数字';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: ResponsiveSize.h(32)),
                            Center(
                              child: ElevatedButton(
                                onPressed: _submitTask,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFE4C4),
                                  foregroundColor: const Color(0xFF8B4513),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.w(40),
                                    vertical: ResponsiveSize.h(16),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                    side: const BorderSide(
                                      color: Color(0xFFDEB887),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '添加任务',
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskNoteController.dispose();
    _taskCountController.dispose();
    super.dispose();
  }
}