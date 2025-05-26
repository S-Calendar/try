// widgets/custom_calendar.dart
import 'package:flutter/material.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime month;

  const CustomCalendar({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int firstWeekday =
        DateTime(month.year, month.month, 1).weekday % 7; // 일요일: 0

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('일'),
            Text('월'),
            Text('화'),
            Text('수'),
            Text('목'),
            Text('금'),
            Text('토'),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 16, // 세로 여백 증가
              childAspectRatio: 1,
            ),
            itemCount: daysInMonth + firstWeekday,
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox(); // 공백 채우기
              }
              int day = index - firstWeekday + 1;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('$day', style: const TextStyle(fontSize: 16)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
