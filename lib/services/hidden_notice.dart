// services/hidden_notices.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

class HiddenNotices {
  static final List<Notice> _hidden = [];

  static List<Notice> get all => List.unmodifiable(_hidden);

  static Future<void> loadHidden() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('hidden_notices') ?? [];
    _hidden.clear();
    _hidden.addAll(
      data.map((jsonStr) {
        final map = json.decode(jsonStr);
        return _noticeFromMap(map);
      }),
    );
  }

  static Future<void> _saveHidden() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _hidden.map((n) => json.encode(_noticeToMap(n))).toList();
    await prefs.setStringList('hidden_notices', data);
  }

  static Future<void> add(Notice notice) async {
    if (!_hidden.any(
      (n) => n.title == notice.title && n.startDate == notice.startDate,
    )) {
      notice.isHidden = true;
      _hidden.add(notice);
      await _saveHidden();
    }
  }

  static Future<void> remove(Notice notice) async {
    _hidden.removeWhere(
      (n) => n.title == notice.title && n.startDate == notice.startDate,
    );
    await _saveHidden();
  }

  static bool contains(Notice notice) {
    return _hidden.any(
      (n) => n.title == notice.title && n.startDate == notice.startDate,
    );
  }

  static Map<String, dynamic> _noticeToMap(Notice n) => {
    'title': n.title,
    'startDate': n.startDate.toIso8601String(),
    'endDate': n.endDate.toIso8601String(),
    'color': n.color.value,
    'url': n.url,
    'memo': n.memo,
    'isHidden': true,
  };

  static Notice _noticeFromMap(Map<String, dynamic> m) => Notice(
    title: m['title'],
    startDate: DateTime.parse(m['startDate']),
    endDate: DateTime.parse(m['endDate']),
    color: Color(m['color']),
    url: m['url'],
    memo: m['memo'],
    category: m['category'],
    isHidden: true,
  );

  static Future<void> unhide(Notice notice) async {
    await remove(notice);
  }
}
