// lib/summary_page.dart
import 'package:flutter/material.dart';
import 'package:scalendar_app/services/gemini_service.dart';
import 'package:scalendar_app/services/web_scraper_service.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final TextEditingController _urlController = TextEditingController();
  final WebScraperService _webScraperService = WebScraperService();
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;
  Map<String, String>? _summaryResults;
  String? _errorMessage;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _summarizeUrl() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _summaryResults = null;
    });

    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _errorMessage = "URL을 입력해주세요.";
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. 웹 페이지 내용 가져오기
      final content = await _webScraperService.fetchAndExtractText(url);

      if (content == null || content.isEmpty) {
        setState(() {
          _errorMessage = "웹 페이지 내용을 가져오거나 파싱하는 데 실패했습니다. URL을 확인해 주세요.";
          _isLoading = false;
        });
        return;
      }

      // 개발자용: 가져온 내용이 너무 길 경우 자르기 (API 토큰 제한 고려)
      // Gemini 1.5 Flash는 1백만 토큰까지 가능하지만, 테스트 목적으로 자를 수 있음.
      // if (content.length > 50000) {
      //   content = content.substring(0, 50000);
      //   print("Warning: Content truncated to 50,000 characters for summarization.");
      // }

      // 2. Gemini API로 요약 요청
      final summary = await _geminiService.summarizeUrlContent(content);

      if (summary == null) {
        setState(() {
          _errorMessage = "요약 내용을 생성하는 데 실패했습니다. 다시 시도해 주세요.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _summaryResults = summary;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "오류가 발생했습니다: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearResults() {
    setState(() {
      _urlController.clear();
      _summaryResults = null;
      _errorMessage = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL 내용 요약')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL 입력',
                hintText: 'https://www.example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _summarizeUrl,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('요약하기'),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _clearResults,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('지우기'),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_summaryResults != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryItem('참가대상', _summaryResults!['참가대상']),
                      _buildSummaryItem('신청방법', _summaryResults!['신청방법']),
                      _buildSummaryItem('내용', _summaryResults!['내용']),
                      _buildSummaryItem('신청기간', _summaryResults!['신청기간']),
                    ],
                  ),
                ),
              ),
            if (_isLoading && _summaryResults == null && _errorMessage == null)
              const Center(child: Text('요약 중입니다... 잠시 기다려 주세요.')),
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
