// notice.dart
import 'package:flutter/material.dart';

class Notice {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String? url;
  final String? writer; // 여기 추가
  final String category; // 카테고리 필드 추가

  bool isFavorite; // 관심 공지 여부
  bool isHidden; // 숨김 여부
  String? memo; // 메모 내용

  Notice({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.category, // 추가
    this.url,
    this.writer, // 생성자에도 추가
    this.isFavorite = false,
    this.isHidden = false,
    this.memo,
  });

  // 신청기간 길이 (띠 우선순위 판단용)
  int get duration => endDate.difference(startDate).inDays + 1;

  // 날짜 포함 여부
  bool includes(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }

  // JSON → Notice
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      color: Color(json['color']), // int로 저장된 color를 복원
      category: json['category'], // 추가
      url: json['url'],
      writer: json['writer'],
      isFavorite: json['isFavorite'] ?? false,
      isHidden: json['isHidden'] ?? false,
      memo: json['memo'],
    );
  }

  // Notice → JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'color': color.value, // int로 변환
      'category': category,  // 추가
      'url': url,
      'writer': writer,
      'isFavorite': isFavorite,
      'isHidden': isHidden,
      'memo': memo,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Notice && title == other.title && startDate == other.startDate;

  @override
  int get hashCode => Object.hash(title, startDate);
}
