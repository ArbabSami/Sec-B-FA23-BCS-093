import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

class FavoritesScreen extends StatefulWidget {
  final int userId;
  const FavoritesScreen({super.key, required this.userId});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  final Map<String, String> languageNames = {
    'en': 'English',
    'ur': 'Urdu',
    'hi': 'Hindi',
    'fr': 'French',
    'de': 'German',
  };

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data =
        await DatabaseHelper.instance.getFavorites(widget.userId);
    setState(() {
      _favorites = data;
      _isLoading = false;
    });
  }

  Future<void> deleteFavorite(int id) async {
    await DatabaseHelper.instance.deleteFavorite(id);
    loadFavorites();
  }

  String formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final item = _favorites[index];
        return Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageNames[item['source_lang']] ??
                      item['source_lang'],
                ),
                const SizedBox(height: 6),
                Text(item['source_text']),
                const SizedBox(height: 6),
                Text(item['translated_text']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate(item['timestamp'])),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                  text:
                                      item['translated_text']),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () =>
                              deleteFavorite(item['id']),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
