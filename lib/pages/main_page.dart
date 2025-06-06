// 📁 lib/main_page.dart
import 'package:flutter/material.dart';
import '../widgets/category_filter_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> selectedCategories = [];

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => CategoryFilterDialog(
        selectedCategories: selectedCategories,
        onApply: (newCategories) {
          setState(() {
            selectedCategories = newCategories;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scalendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showCategoryDialog,
          ),
        ],
      ),
      body: Center(
        child: Text(
          selectedCategories.isEmpty
              ? '선택된 카테고리 없음'
              : '선택된 카테고리: ${selectedCategories.join(', ')}',
        ),
      ),
    );
  }
}
