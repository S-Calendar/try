import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

class NoticeData {
  static Future<List<Notice>> loadNoticesFromFirestore() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('notices').get();
    List<Notice> all = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      try {
        final start = DateTime.parse(data['startDate']);
        final end = DateTime.parse(data['endDate']);

        Color color;
        switch (data['category']) {
          case '학사공지':
            color = const Color(0x83ABC9FF);
            break;
          case 'ai학과공지':
            color = const Color(0x83FFABAB);
            break;
          case '취업공지':
            color = const Color(0x83A5FAA5);
            break;
          default:
            color = const Color.fromARGB(131, 171, 200, 255);
        }

        all.add(
          Notice(
            title: data['title'] ?? '제목 없음',
            startDate: start,
            endDate: end,
            color: color,
            url: data['url'],
            writer: data['writer'],
            isFavorite: data['isFavorite'] ?? false,
            isHidden: data['isHidden'] ?? false,
            memo: data['memo'],
          ),
        );
      } catch (e) {
        continue;
      }
    }

    return all;
  }
}

class FavoriteNotices {
  static List<Notice> favorites = [];

  static Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorite_notices');
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      favorites = decoded.map((e) => Notice.fromJson(e)).toList();
    } else {
      favorites = [];
    }
  }

  static Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      favorites.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('favorite_notices', encoded);
  }

  static Future<void> toggle(Notice notice) async {
    final exists = favorites.any((n) => n.url == notice.url);
    if (exists) {
      favorites.removeWhere((n) => n.url == notice.url);
    } else {
      favorites.add(notice);
    }
    await saveFavorites();
  }

  static Future<void> remove(Notice notice) async {
    favorites.removeWhere((n) => n.url == notice.url);
    await saveFavorites();
  }
}
