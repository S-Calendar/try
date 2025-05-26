import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:AI/pages/summary_page.dart'; // 다음 단계에서 만들 페이지
import 'package:AI/favorite_notices_page.dart';
import 'package:AI/hidden_items_page.dart';
import 'package:AI/settings_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Summarizer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SettingsPage(), // 요약 페이지를 홈으로 설정
    );
  }
}
