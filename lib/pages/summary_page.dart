// pages/summary_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scalendar_app/services/gemini_service.dart';
import 'package:scalendar_app/services/web_scraper_service.dart';

class SummaryPage extends StatefulWidget {
  final String initialUrl;
  final String noticeTitle;
  final Color noticeColor;

  const SummaryPage({
    super.key,
    required this.initialUrl,
    required this.noticeTitle,
    required this.noticeColor,
  });

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final WebScraperService _webScraperService = WebScraperService();
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = true;
  Map<String, String>? _summaryResults;
  String? _errorMessage;
  String? _memo;

  @override
  void initState() {
    super.initState();
    _summarizeFromInitialUrl();
  }

  Future<void> _summarizeFromInitialUrl() async {
    try {
      final content = await _webScraperService.fetchAndExtractText(
        widget.initialUrl,
      );
      if (content == null || content.isEmpty) {
        setState(() {
          _errorMessage = "웹 페이지 내용을 가져오거나 파싱하는 데 실패했습니다.";
          _isLoading = false;
        });
        return;
      }

      final summary = await _geminiService.summarizeUrlContent(content);
      if (summary == null) {
        setState(() {
          _errorMessage = "요약 내용을 생성하는 데 실패했습니다.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _summaryResults = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "오류 발생: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse(widget.initialUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("링크를 열 수 없습니다.")));
    }
  }

  void _showMemoDialog() {
    final TextEditingController controller = TextEditingController(text: _memo);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('메모 수정'),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(hintText: '메모를 입력하세요'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _memo = controller.text);
                  Navigator.pop(context);
                },
                child: const Text('저장'),
              ),
            ],
          ),
    );
  }

  void _hideNotice() {
    // 향후 설정 페이지에서 관리할 수 있도록 처리 예정
    Navigator.pop(context); // 요약 페이지 닫기 (숨김 효과)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('공지 요약'),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 24,
                            decoration: BoxDecoration(
                              color: widget.noticeColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.noticeTitle,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSummaryItem('참가대상', _summaryResults!["참가대상"]),
                    _buildSummaryItem('신청기간', _summaryResults!["신청기간"]),
                    _buildSummaryItem('신청방법', _summaryResults!["신청방법"]),
                    _buildSummaryItem('내용', _summaryResults!["내용"]),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _launchUrl,
                      child: const Text(
                        '홈페이지 바로가기',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      '메모:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (_memo != null && _memo!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(_memo!),
                      ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _showMemoDialog,
                          child: const Text('수정'),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: _hideNotice,
                          child: const Text('숨기기'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSummaryItem(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(content ?? '정보 없음', style: const TextStyle(fontSize: 14.0)),
        ],
      ),
    );
  }
}
