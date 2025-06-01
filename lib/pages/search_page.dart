import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../utils/notice_data.dart';
import 'summary_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Notice> _allNotices = [];
  List<Notice> _filteredNotices = [];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    final notices = await NoticeData.loadNoticesFromAssets();
    setState(() {
      _allNotices = notices;
      _filteredNotices = notices;
    });
  }

  void _filterNotices(String keyword) {
    setState(() {
      _filteredNotices = _allNotices
          .where((notice) => notice.title.contains(keyword))
          .toList();
    });
  }

  void _navigateToSummary(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("공지사항 검색")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "검색어를 입력하세요",
                border: OutlineInputBorder(),
              ),
              onChanged: _filterNotices,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNotices.length,
                itemBuilder: (context, index) {
                  final notice = _filteredNotices[index];
                  return ListTile(
                    title: Text(notice.title),
                    subtitle: Text(notice.author ?? ''),
                    onTap: notice.url != null
                        ? () => _navigateToSummary(notice.url!)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

