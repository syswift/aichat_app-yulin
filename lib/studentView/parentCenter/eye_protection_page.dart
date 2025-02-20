import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class EyeProtectionPage extends StatefulWidget {
  const EyeProtectionPage({super.key});

  @override
  State<EyeProtectionPage> createState() => _EyeProtectionPageState();
}

class _EyeProtectionPageState extends State<EyeProtectionPage> {
  bool _isProtectionEnabled = true;
  double _maxScreenTime = 120;
  double _restInterval = 30;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parentbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(40),
                    vertical: ResponsiveSize.h(20),
                  ),
                  child: Column(
                    children: [
                      _buildMainSwitch(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildTimeSettings(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildRestSettings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/backbutton1.png',
              width: ResponsiveSize.w(100),
              height: ResponsiveSize.h(100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSwitch() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '时间管理',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isProtectionEnabled,
                onChanged: (value) {
                  setState(() => _isProtectionEnabled = value);
                },
                activeColor: const Color(0xFF88c5fd),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          Text(
            '开启后将自动管理使用时间，培养良好的使用习惯',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildTimeSettings() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '使用时间设置',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildTimePicker('开始时间', _startTime, (time) {
            if (time != null) setState(() => _startTime = time);
          }),
          SizedBox(height: ResponsiveSize.h(20)),
          _buildTimePicker('结束时间', _endTime, (time) {
            if (time != null) setState(() => _endTime = time);
          }),
          SizedBox(height: ResponsiveSize.h(20)),
          Text(
            '建议设置合理的使用时间段，避免孩子在就寝时间使用设备',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    String title,
    TimeOfDay time,
    Function(TimeOfDay?) onTimeSelected,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF88c5fd),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            onTimeSelected(picked);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(20),
              vertical: ResponsiveSize.h(10),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF88c5fd).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
            ),
            child: Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: const Color(0xFF88c5fd),
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
    Widget _buildRestSettings() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '使用时长设置',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildSliderSetting(
            '单次使用时长',
            _maxScreenTime,
            30,
            240,
            14,
            '分钟',
            (value) => setState(() => _maxScreenTime = value),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildSliderSetting(
            '休息间隔时间',
            _restInterval,
            15,
            60,
            9,
            '分钟',
            (value) => setState(() => _restInterval = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    double min,
    double max,
    int divisions,
    String unit,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(12),
                vertical: ResponsiveSize.h(6),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF88c5fd).withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
              ),
              child: Text(
                '${value.toInt()}$unit',
                style: TextStyle(
                  color: const Color(0xFF88c5fd),
                  fontSize: ResponsiveSize.sp(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveSize.h(20)),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: ResponsiveSize.h(8),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: ResponsiveSize.w(12),
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: ResponsiveSize.w(24),
            ),
            activeTrackColor: const Color(0xFF88c5fd),
            inactiveTrackColor: const Color(0xFF88c5fd).withOpacity(0.1),
            thumbColor: const Color(0xFF88c5fd),
            overlayColor: const Color(0xFF88c5fd).withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: _isProtectionEnabled ? onChanged : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$min$unit',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveSize.sp(12),
              ),
            ),
            Text(
              '$max$unit',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveSize.sp(12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}