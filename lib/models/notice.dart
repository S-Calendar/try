// notice.dart
import 'package:flutter/material.dart';

class Notice {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;

  /// 관심 공지 여부
  bool isFavorite;

  Notice({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    this.isFavorite = false,
  });

  // 신청기간 길이 (띠 우선순위 판단용)
  int get duration => endDate.difference(startDate).inDays + 1;

  // 날짜 포함 여부
  bool includes(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }

  @override
  bool operator ==(Object other) =>
      other is Notice &&
      title == other.title &&
      startDate == other.startDate;

  @override
  int get hashCode => Object.hash(title, startDate);
}
