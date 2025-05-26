// favorite_notices_page.dart
import 'package:flutter/material.dart';

class FavoriteNoticesPage extends StatelessWidget {
  const FavoriteNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteItems = ['관심 공지 1', '관심 공지 2'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 공지 편집'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(favoriteItems[index]),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    // 삭제 기능 구현 가능
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
