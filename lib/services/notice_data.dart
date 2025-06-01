// notice_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/notice.dart';

class NoticeData {
  static Future<List<Notice>> loadNoticesFromJson(BuildContext context) async {
    final String jsonString = await rootBundle.loadString(
      'assets/임시2_추가_output.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    List<Notice> all = [];

    jsonMap.forEach((category, notices) {
      for (var item in notices) {
        final title = item['제목'] ?? '제목 없음';
        final term = item['신청기간'] ?? item['결과발표일(하는날)'] ?? item['결과발표일'] ?? '';
        final dates = term.split('~').map((s) => s.trim()).toList();
        final url = item['상세 링크'];

        if (dates.isEmpty || dates.first.isEmpty) continue;

        try {
          final start = DateTime.parse(dates[0].replaceAll('.', '-'));
          final end =
              (dates.length > 1)
                  ? DateTime.parse(dates[1].replaceAll('.', '-'))
                  : start;

          Color color;
          if (category == '학사공지') {
            color = const Color(0x83ABC9FF); // 50% 투명도
          } else if (category == 'ai학과공지') {
            color = const Color(0x83FFABAB);
          } else if (category == '취업공지') {
            color = const Color(0x83A5FAA5);
          } else {
            color = const Color.fromARGB(131, 171, 200, 255); // 기본 fallback
          }

          all.add(
            Notice(
              title: title,
              startDate: start,
              endDate: end,
              color: color,
              url: url,
            ),
          );
        } catch (_) {
          continue; // 날짜 파싱 실패 → 건너뜀
        }
      }
    });

    return all;
  }
}
