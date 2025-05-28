import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../widgets/notice_modal.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime month;
  final List<Notice> notices;

  const CustomCalendar({super.key, required this.month, required this.notices});

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    return Column(
      children: [
        const SizedBox(height: 10),
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
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 60,
              childAspectRatio: 1.0,
            ),
            itemCount: daysInMonth + firstWeekday,
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox();
              }

              int day = index - firstWeekday + 1;
              final date = DateTime(month.year, month.month, day);
              final dailyNotices =
                  notices.where((n) => n.includes(date)).toList()
                    ..sort((a, b) => a.duration.compareTo(b.duration));

              return GestureDetector(
                onTap: () {
                  final noticesOnThisDay = dailyNotices;
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder:
                        (_) => NoticeBottomSheet(
                          date: date,
                          notices: noticesOnThisDay,
                        ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$day', style: const TextStyle(fontSize: 16)),
                    ...dailyNotices
                        .take(4)
                        .map(
                          (notice) => Container(
                            height: 14,
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: notice.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              notice.title,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    if (dailyNotices.length > 4)
                      Text(
                        '+${dailyNotices.length - 4}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
