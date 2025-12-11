import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List submissions = [];

  Future<void> loadData() async {
    submissions = await SupabaseService.getSubmissions();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Submissions")),
      body: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          final item = submissions[index];
          return Card(
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['email']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await SupabaseService.deleteSubmission(item['id']);
                      loadData();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
