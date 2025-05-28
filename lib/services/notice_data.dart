import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/notice.dart';

class NoticeData {
  static Future<List<Notice>> loadNoticesFromJson(BuildContext context) async {
    final String jsonString = await rootBundle.loadString(
      'assets/임시2_output.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    List<Notice> all = [];

    jsonMap.forEach((category, notices) {
      for (var item in notices) {
        final title = item['제목'] ?? '제목 없음';
        final term = item['신청기간'] ?? item['결과발표일(하는날)'] ?? '';
        final dates = term.split('~').map((s) => s.trim()).toList();

        if (dates.isEmpty || dates.first.isEmpty) continue;

        try {
          final start = DateTime.parse(dates[0].replaceAll('.', '-'));
          final end =
              (dates.length > 1)
                  ? DateTime.parse(dates[1].replaceAll('.', '-'))
                  : start;

          all.add(
            Notice(
              title: title,
              startDate: start,
              endDate: end,
              color:
                  category == 'ai학과공지'
                      ? const Color(0xFFFFABAB)
                      : const Color(0xFFABC9FF),
            ),
          );
        } catch (_) {
          // 날짜 파싱 실패 → 건너뜀
          continue;
        }
      }
    });

    return all;
  }
}
