// pages/main_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_calendar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final int baseYear = 2024;
  late final PageController _pageController;
  late int _selectedIndex;
  late int _todayIndex;

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();
    _todayIndex = (today.year - baseYear) * 12 + (today.month - 1);
    _selectedIndex = _todayIndex;
    _pageController = PageController(initialPage: _todayIndex);
  }

  @override
  Widget build(BuildContext context) {
    final int year = baseYear + (_selectedIndex ~/ 12);
    final int month = (_selectedIndex % 12) + 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 고정 UI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    child: Image.asset('assets/setting_icon.png', width: 32),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = _todayIndex;
                        _pageController.jumpToPage(_todayIndex);
                      });
                    },
                    child: Image.asset('assets/today_icon.png', width: 70),
                  ),
                  Text(
                    '$month월',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/search'),
                    child: Image.asset('assets/search_icon.png', width: 32),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/filter'),
                    child: Image.asset(
                      'assets/colorfilter_icon.png',
                      width: 44,
                    ),
                  ),
                ],
              ),
            ),

            // 달력 영역
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final int year = baseYear + (index ~/ 12);
                  final int month = (index % 12) + 1;
                  final DateTime currentMonth = DateTime(year, month);
                  return CustomCalendar(month: currentMonth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
