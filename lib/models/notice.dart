import 'package:flutter/material.dart';

class Notice {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;

  Notice({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
  });

  // 신청기간 길이 (띠 우선순위 판단용)
  int get duration => endDate.difference(startDate).inDays + 1;

  // 해당 날짜가 포함되는지 여부
  bool includes(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }
}
