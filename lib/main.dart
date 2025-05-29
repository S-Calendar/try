// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splash_page.dart';
import 'pages/start_page.dart';
import 'pages/main_page.dart';
import 'pages/search_page.dart'; // 올바른 경로와 이름으로 수정




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCalendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // splash부터 시작
      routes: {
        '/': (context) => const StartPage(),
        '/main_page': (context) => const MainPage(),
        '/search': (context) => const SearchPage(), // ✅ 검색 페이지 라우트 추가
      },
    );
  }
}
