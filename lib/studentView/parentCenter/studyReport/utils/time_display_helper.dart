class TimeDisplayHelper {
  static String getPeriodTitle(String reportType) {
    switch (reportType) {
      case 'daily':
        return '今日';
      case 'weekly':
        return '本周';
      case 'monthly':
        return '本月';
      case 'yearly':
        return '今年';
      default:
        return '';
    }
  }

  static int getBaseValue(String reportType) {
    switch (reportType) {
      case 'daily':
        return 120;    // 每个时段最大120分钟
      case 'weekly':
        return 300;    // 每天最大300分钟
      case 'monthly':
        return 1500;   // 每周最大1500分钟
      case 'yearly':
        return 6000;   // 每月最大6000分钟
      default:
        return 100;
    }
  }

  static String getTimeUnitText(String reportType) {
    switch (reportType) {
      case 'daily':
        return '时段学习时长';
      case 'weekly':
        return '每日学习时长';
      case 'monthly':
        return '每周学习时长';
      case 'yearly':
        return '每月学习时长';
      default:
        return '学习时长';
    }
  }

  // 新增方法：根据报告类型和时间段获取显示标签
  static String getTimeLabel(String reportType, String timeSlot) {
    switch (reportType) {
      case 'daily':
        // 假设 timeSlot 格式为 "HH:mm"
        return timeSlot;
      case 'weekly':
        // 假设 timeSlot 为 1-7，表示周几
        switch (timeSlot) {
          case '1': return '周一';
          case '2': return '周二';
          case '3': return '周三';
          case '4': return '周四';
          case '5': return '周五';
          case '6': return '周六';
          case '7': return '周日';
          default: return timeSlot;
        }
      case 'monthly':
        // 假设 timeSlot 格式为 "W1" 到 "W5"，表示第几周
        return '第${timeSlot.substring(1)}周';
      case 'yearly':
        // 假设 timeSlot 格式为 "1" 到 "12"，表示月份
        return '$timeSlot月';
      default:
        return timeSlot;
    }
  }
} 