import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class Prize {
  final String name;
  final int points;
  final String image;
  final String description;
  int stock;
  File? localImage;

  Prize({
    required this.name,
    required this.points,
    required this.image,
    required this.stock,
    required this.description,
    this.localImage,
  });
}

class PointsShopManagePage extends StatefulWidget {
  const PointsShopManagePage({super.key});

  @override
  State<PointsShopManagePage> createState() => _PointsShopManagePageState();
}

class _PointsShopManagePageState extends State<PointsShopManagePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<Prize> _selectedPrizes = {};
  bool _isDeleteMode = false;
  File? _tempImage;

  final List<Prize> _prizes = [
    Prize(
      name: '文具套装',
      points: 200,
      image: 'assets/prize1.png',
      stock: 50,
      description: '优质文具套装，包含铅笔、橡皮、尺子等',
    ),
    Prize(
      name: '精美笔记本',
      points: 150,
      image: 'assets/prize2.png',
      stock: 30,
      description: 'A5大小，优质纸张，适合日常记录',
    ),
    Prize(
      name: '儿童故事书',
      points: 180,
      image: 'assets/prize2.png',
      stock: 25,
      description: '精选儿童文学作品，图文并茂',
    ),
    Prize(
      name: '运动水杯',
      points: 120,
      image: 'assets/prize2.png',
      stock: 40,
      description: '便携运动水杯，防漏耐用',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveSize.h(32)),
            Expanded(
              child: _buildPrizesContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/backbutton1.png',
            width: ResponsiveSize.w(80),
            height: ResponsiveSize.h(80),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(20)),
        Text(
          '积分商城',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        const Spacer(),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: ResponsiveSize.w(300),
      height: ResponsiveSize.h(46),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(23)),
        border: Border.all(color: const Color(0xFFDEB887)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            height: 1.0,
          ),
          decoration: InputDecoration(
            hintText: '搜索奖品',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: ResponsiveSize.sp(16),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
              size: ResponsiveSize.w(20),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveSize.h(13),
              horizontal: ResponsiveSize.w(16),
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildPrizesContent() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(32)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '奖品管理',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
              Row(
                children: [
                  _buildExchangeButton('添加奖品', Icons.add),
                  SizedBox(width: ResponsiveSize.w(16)),
                  if (_isDeleteMode)
                    _buildDeleteButton()
                  else
                    _buildDeleteModeButton(),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(24)),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                crossAxisSpacing: ResponsiveSize.w(20),
                mainAxisSpacing: ResponsiveSize.h(20),
              ),
              itemCount: _prizes.length,
              itemBuilder: (context, index) => _buildPrizeCard(_prizes[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeCard(Prize prize) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            border: Border.all(color: const Color(0xFFDEB887)),
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
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveSize.w(8)),
                  child: Center(
                    child: prize.localImage != null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              return FutureBuilder<Size>(
                                future: _getImageSize(prize.localImage!),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const SizedBox();
                                  
                                  final imageSize = snapshot.data!;
                                  final containerSize = Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight
                                  );
                                  
                                  final fitSize = _calculateFitSize(
                                    imageSize,
                                    containerSize
                                  );
                                  
                                  return SizedBox(
                                    width: fitSize.width,
                                    height: fitSize.height,
                                    child: Image.file(
                                      prize.localImage!,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Image.asset(
                            prize.image,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prize.name,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveSize.h(4)),
                      Text(
                        prize.description,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${prize.points}积分',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '库存: ${prize.stock}',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  color: Colors.grey[600],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showUpdateStockDialog(prize),
                                icon: Icon(
                                  Icons.edit,
                                  size: ResponsiveSize.w(20),
                                  color: const Color(0xFF8B4513),
                                ),
                                tooltip: '修改库存',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.h(36),
                        child: ElevatedButton(
                          onPressed: () => _showEditPrizeDialog(prize),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF8B4513),
                            backgroundColor: const Color(0xFFFFE4C4),
                            textStyle: TextStyle(fontSize: ResponsiveSize.sp(18)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              side: const BorderSide(color: Color(0xFFDEB887)),
                            ),
                          ),
                          child: const Text('编辑'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isDeleteMode)
          Positioned(
            top: ResponsiveSize.h(8),
            left: ResponsiveSize.w(8),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_selectedPrizes.contains(prize)) {
                    _selectedPrizes.remove(prize);
                  } else {
                    _selectedPrizes.add(prize);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                ),
                child: Icon(
                  _selectedPrizes.contains(prize)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: ResponsiveSize.w(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExchangeButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _showAddPrizeDialog(),
      icon: Icon(
        icon,
        size: ResponsiveSize.w(24),
        color: const Color(0xFF8B4513),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(20),
          color: const Color(0xFF8B4513),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE4C4),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(16)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          side: const BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton.icon(
      onPressed: _selectedPrizes.isEmpty ? null : _deleteSelectedPrizes,
      icon: Icon(
        Icons.delete,
        size: ResponsiveSize.w(24),
        color: Colors.red,
      ),
      label: Text(
        '删除奖品(${_selectedPrizes.length})',
        style: TextStyle(
          fontSize: ResponsiveSize.sp(20),
          color: Colors.red,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE4C4),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(16)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          side: const BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
    );
  }

  Widget _buildDeleteModeButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _isDeleteMode = true;
        });
      },
      icon: Icon(
        Icons.delete_outline,
        size: ResponsiveSize.w(24),
        color: const Color(0xFF8B4513),
      ),
      label: Text(
        '删除奖品',
        style: TextStyle(
          fontSize: ResponsiveSize.sp(20),
          color: const Color(0xFF8B4513),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE4C4),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(16)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          side: const BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
    );
  }

  void _showUpdateStockDialog(Prize prize) {
    final TextEditingController stockController = TextEditingController(text: prize.stock.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '修改库存 - ${prize.name}',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '库存数量',
                labelStyle: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: const Color(0xFF8B4513),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            Text(
              '当前库存：${prize.stock}',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null && newStock >= 0) {
                setState(() {
                  prize.stock = newStock;
                });
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '库存更新成功！',
                      style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '请输入有效的库存数量',
                      style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              '确定',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
      ),
    );
  }

  void _showAddPrizeDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController pointsController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    _tempImage = null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        child: Container(
          width: ResponsiveSize.w(800),
          padding: EdgeInsets.all(ResponsiveSize.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '添加奖品',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: ResponsiveSize.w(24),
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(24)),
              Flexible(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ResponsiveSize.w(300),
                        height: ResponsiveSize.h(300),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          border: Border.all(color: const Color(0xFFDEB887)),
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) => Stack(
                            children: [
                              if (_tempImage != null)
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return FutureBuilder<Size>(
                                          future: _getImageSize(_tempImage!),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) return const SizedBox();
                                            
                                            final imageSize = snapshot.data!;
                                            final containerSize = Size(
                                              constraints.maxWidth,
                                              constraints.maxHeight
                                            );
                                            
                                            final fitSize = _calculateFitSize(
                                              imageSize,
                                              containerSize
                                            );
                                            
                                            return SizedBox(
                                              width: fitSize.width,
                                              height: fitSize.height,
                                              child: Image.file(
                                                _tempImage!,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                Center(
                                  child: Icon(
                                    Icons.image,
                                    size: ResponsiveSize.w(80),
                                    color: Colors.grey[400],
                                  ),
                                ),
                              Positioned(
                                bottom: ResponsiveSize.h(16),
                                right: ResponsiveSize.w(16),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await showDialog<XFile>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            '选择图片来源',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(24),
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF8B4513),
                                            ),
                                          ),
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.photo_library,
                                                      size: ResponsiveSize.w(40),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                    onPressed: () async {
                                                      final XFile? image = await picker.pickImage(
                                                        source: ImageSource.gallery,
                                                      );
                                                      Navigator.pop(context, image);
                                                    },
                                                  ),
                                                  Text(
                                                    '从相册选择',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(16),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      size: ResponsiveSize.w(40),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                    onPressed: () async {
                                                      final XFile? image = await picker.pickImage(
                                                        source: ImageSource.camera,
                                                      );
                                                      Navigator.pop(context, image);
                                                    },
                                                  ),
                                                  Text(
                                                    '拍照',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(16),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    if (image != null) {
                                      setState(() {
                                        _tempImage = File(image.path);
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: ResponsiveSize.w(20),
                                  ),
                                  label: Text(
                                    '上传图片',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(16),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFE4C4),
                                    foregroundColor: const Color(0xFF8B4513),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(24)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: '奖品名称',
                                labelStyle: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  color: const Color(0xFF8B4513),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: pointsController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: '所需积分',
                                      labelStyle: TextStyle(
                                        fontSize: ResponsiveSize.sp(18),
                                        color: const Color(0xFF8B4513),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(16)),
                                Expanded(
                                  child: TextField(
                                    controller: stockController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: '库存数量',
                                      labelStyle: TextStyle(
                                        fontSize: ResponsiveSize.sp(18),
                                        color: const Color(0xFF8B4513),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            TextField(
                              controller: descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: '奖品描述',
                                labelStyle: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  color: const Color(0xFF8B4513),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _tempImage = null;
                      Navigator.pop(context);
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final points = int.tryParse(pointsController.text);
                      final stock = int.tryParse(stockController.text);
                      final description = descriptionController.text;

                      if (name.isNotEmpty && points != null && stock != null && description.isNotEmpty && _tempImage != null) {
                        setState(() {
                          _prizes.add(Prize(
                            name: name,
                            points: points,
                            image: 'assets/prize1.png',
                            stock: stock,
                            description: description,
                            localImage: _tempImage,
                          ));
                        });
                        _tempImage = null;
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '奖品添加成功！',
                              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '请填写完整的奖品信息并上传图片',
                              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4C4),
                      foregroundColor: const Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(32),
                        vertical: ResponsiveSize.h(16),
                      ),
                    ),
                    child: Text(
                      '添加',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(Prize? prize) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '选择图片来源',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.photo_library,
                      size: ResponsiveSize.w(40),
                      color: const Color(0xFF8B4513),
                    ),
                    onPressed: () async {
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      Navigator.pop(context, image);
                    },
                  ),
                  Text(
                    '从相册选择',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: ResponsiveSize.w(40),
                      color: const Color(0xFF8B4513),
                    ),
                    onPressed: () async {
                      final XFile? image = await picker.pickImage(source: ImageSource.camera);
                      Navigator.pop(context, image);
                    },
                  ),
                  Text(
                    '拍照',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      setState(() {
        if (prize != null) {
          prize.localImage = File(image.path);
        }
      });
    }
  }

  void _showEditPrizeDialog(Prize prize) {
    final TextEditingController nameController = TextEditingController(text: prize.name);
    final TextEditingController pointsController = TextEditingController(text: prize.points.toString());
    final TextEditingController stockController = TextEditingController(text: prize.stock.toString());
    final TextEditingController descriptionController = TextEditingController(text: prize.description);
    File? tempImage = prize.localImage;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        child: Container(
          width: ResponsiveSize.w(800),
          padding: EdgeInsets.all(ResponsiveSize.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '编辑奖品',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatefulBuilder(
                        builder: (context, setDialogState) => Container(
                          width: ResponsiveSize.w(300),
                          height: ResponsiveSize.h(300),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            border: Border.all(color: const Color(0xFFDEB887)),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return FutureBuilder<Size>(
                                        future: tempImage != null 
                                            ? _getImageSize(tempImage!)
                                            : null,
                                        builder: (context, snapshot) {
                                          if (tempImage != null) {
                                            if (!snapshot.hasData) return const SizedBox();
                                            
                                            final imageSize = snapshot.data!;
                                            final containerSize = Size(
                                              constraints.maxWidth,
                                              constraints.maxHeight
                                            );
                                            
                                            final fitSize = _calculateFitSize(
                                              imageSize,
                                              containerSize
                                            );
                                            
                                            return SizedBox(
                                              width: fitSize.width,
                                              height: fitSize.height,
                                              child: Image.file(
                                                tempImage!,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          } else {
                                            return Image.asset(
                                              prize.image,
                                              fit: BoxFit.contain,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: ResponsiveSize.h(16),
                                right: ResponsiveSize.w(16),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await showDialog<XFile>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            '选择图片来源',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(24),
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF8B4513),
                                            ),
                                          ),
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.photo_library,
                                                      size: ResponsiveSize.w(40),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                    onPressed: () async {
                                                      final XFile? image = await picker.pickImage(
                                                        source: ImageSource.gallery,
                                                      );
                                                      Navigator.pop(context, image);
                                                    },
                                                  ),
                                                  Text(
                                                    '从相册选择',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(16),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      size: ResponsiveSize.w(40),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                    onPressed: () async {
                                                      final XFile? image = await picker.pickImage(
                                                        source: ImageSource.camera,
                                                      );
                                                      Navigator.pop(context, image);
                                                    },
                                                  ),
                                                  Text(
                                                    '拍照',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(16),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    if (image != null) {
                                      setDialogState(() {
                                        tempImage = File(image.path);
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFE4C4),
                                    foregroundColor: const Color(0xFF8B4513),
                                  ),
                                  icon: Icon(
                                    Icons.photo_camera,
                                    size: ResponsiveSize.w(20),
                                  ),
                                  label: Text(
                                    '更换图片',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(24)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: '奖品名称',
                                labelStyle: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  color: const Color(0xFF8B4513),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: pointsController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: '所需积分',
                                      labelStyle: TextStyle(
                                        fontSize: ResponsiveSize.sp(18),
                                        color: const Color(0xFF8B4513),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(16)),
                                Expanded(
                                  child: TextField(
                                    controller: stockController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: '库存数量',
                                      labelStyle: TextStyle(
                                        fontSize: ResponsiveSize.sp(18),
                                        color: const Color(0xFF8B4513),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            TextField(
                              controller: descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: '奖品描述',
                                labelStyle: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  color: const Color(0xFF8B4513),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      tempImage = null;
                      Navigator.pop(context);
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final points = int.tryParse(pointsController.text);
                      final stock = int.tryParse(stockController.text);
                      final description = descriptionController.text;

                      if (name.isNotEmpty && points != null && stock != null && description.isNotEmpty) {
                        setState(() {
                          final index = _prizes.indexOf(prize);
                          if (index != -1) {
                            _prizes[index] = Prize(
                              name: name,
                              points: points,
                              image: prize.image,
                              stock: stock,
                              description: description,
                              localImage: tempImage,
                            );
                          }
                        });
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '奖品更新成功！',
                              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '请填写完整的奖品信息',
                              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4C4),
                      foregroundColor: const Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(32),
                        vertical: ResponsiveSize.h(16),
                      ),
                    ),
                    child: Text(
                      '保存',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSelectedPrizes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '删除奖品',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        content: Text(
          '确定要删除选中的${_selectedPrizes.length}个奖品吗？',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: const Color(0xFF8B4513),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedPrizes.clear();
                _isDeleteMode = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _prizes.removeWhere((prize) => _selectedPrizes.contains(prize));
                _selectedPrizes.clear();
                _isDeleteMode = false;
              });
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '奖品删除成功！',
                    style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              '删除',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: Colors.red,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
      ),
    );
  }

  Future<Size> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer();
    final image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        },
      ),
    );
    return completer.future;
  }

  Size _calculateFitSize(Size imageSize, Size containerSize) {
    final double aspectRatio = imageSize.width / imageSize.height;
    double width = containerSize.width;
    double height = containerSize.height;
    
    if (width / height > aspectRatio) {
      width = height * aspectRatio;
    } else {
      height = width / aspectRatio;
    }
    
    if (width > containerSize.width) {
      width = containerSize.width;
      height = width / aspectRatio;
    }
    if (height > containerSize.height) {
      height = containerSize.height;
      width = height * aspectRatio;
    }
    
    return Size(width, height);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 