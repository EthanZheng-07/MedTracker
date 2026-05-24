import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final db = DatabaseHelper.instance;

  List<Map<String, dynamic>> logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  void loadLogs() async {
    final data = await db.getLogs();

    setState(() {
      logs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text('No medication history yet'),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];

                return ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: Text(log['name']),
                  subtitle: Text(
                    'Taken at: ${log['takenAt']}',
                  ),
                );
              },
            ),
    );
  }
}