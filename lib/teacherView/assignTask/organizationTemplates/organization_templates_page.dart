import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../myTemplates/my_templates_page.dart';
import '../myTemplates/class_task_assignment.dart';
import '../../../utils/responsive_size.dart';  // 添加响应式尺寸工具

class OrganizationTemplatesPage extends StatefulWidget {
  const OrganizationTemplatesPage({super.key});

  @override
  State<OrganizationTemplatesPage> createState() => _OrganizationTemplatesPageState();
}

class _OrganizationTemplatesPageState extends State<OrganizationTemplatesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<TemplateItem> templateList = [];

  static final List<HeaderItem> headers = [
    HeaderItem(title: '任务模板', flex: 3),
    HeaderItem(title: '备注', flex: 3),
    HeaderItem(title: '布置', flex: 1),
    HeaderItem(title: '操作', flex: 1),
  ];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }
  Future<void> _loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templates = prefs.getStringList('organization_templates') ?? [];
    setState(() {
      templateList = templates
          .map((template) => TemplateItem.fromJson(json.decode(template)))
          .toList();
    });
  }

  List<TemplateItem> _getFilteredList() {
    if (_searchController.text.isEmpty) {
      return templateList;
    }
    return templateList.where((item) {
      return item.name.contains(_searchController.text) ||
             item.note.contains(_searchController.text);
    }).toList();
  }

  Future<void> _deleteTemplate(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> templates = prefs.getStringList('organization_templates') ?? [];
    templates.removeAt(index);
    await prefs.setStringList('organization_templates', templates);
    setState(() {
      templateList.removeAt(index);
    });
  }

  void _assignTask(TemplateItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassTaskAssignmentPage(template: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Container(
      padding: EdgeInsets.only(top: ResponsiveSize.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: ResponsiveSize.w(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '机构模板',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(28),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                                Row(
                  children: [
                    if (_isSearching)
                      Container(
                        width: ResponsiveSize.w(200),
                        height: ResponsiveSize.h(40),
                        margin: EdgeInsets.only(right: ResponsiveSize.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(16),
                            color: const Color(0xFF333333),
                          ),
                          decoration: InputDecoration(
                            hintText: '搜索模板',
                            hintStyle: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: const Color(0xFF999999),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: ResponsiveSize.h(8),
                              horizontal: ResponsiveSize.w(16),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                          }
                        });
                      },
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        size: ResponsiveSize.w(28),
                        color: const Color(0xFF666666),
                      ),
                      label: Text(
                        _isSearching ? '关闭' : '搜索',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          color: const Color(0xFF666666),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(16),
                          vertical: ResponsiveSize.h(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
                    SizedBox(height: ResponsiveSize.h(24)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.w(16)),
                  bottomLeft: Radius.circular(ResponsiveSize.w(16)),
                ),
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(24),
                      vertical: ResponsiveSize.h(16),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4C4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: ResponsiveSize.w(10),
                          offset: Offset(0, ResponsiveSize.h(4)),
                        ),
                      ],
                    ),
                    child: Row(
                      children: headers.map((header) => _buildHeaderItem(header)).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _getFilteredList().length,
                      itemBuilder: (context, index) {
                        final item = _getFilteredList()[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(24),
                            vertical: ResponsiveSize.h(20),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                          ),
                                                    child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ResponsiveSize.w(120),
                                        height: ResponsiveSize.h(120),
                                        margin: EdgeInsets.only(right: ResponsiveSize.w(12)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                          child: item.cover.startsWith('assets/')
                                              ? Image.asset(
                                                  item.cover,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(item.cover),
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: Colors.grey[800],
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(12)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    item.note,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                                                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _assignTask(item),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/assignmentbutton.png',
                                          width: ResponsiveSize.w(50),
                                          height: ResponsiveSize.h(50),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(4)),
                                        Text(
                                          '布置',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: PopupMenuButton(
                                    icon: Icon(
                                      Icons.settings,
                                      color: const Color(0xFF666666),
                                      size: ResponsiveSize.w(35),
                                    ),
                                    offset: Offset(ResponsiveSize.w(35), ResponsiveSize.h(50)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                    ),
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        height: ResponsiveSize.h(40),
                                        child: Center(
                                          child: Text(
                                            '删除',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(20),
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        onTap: () => _deleteTemplate(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildHeaderItem(HeaderItem header) {
    return Expanded(
      flex: header.flex,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              header.title,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(25),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            if (header.title == '备注')
              Text(
                ' (仅老师及以上可见)',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
