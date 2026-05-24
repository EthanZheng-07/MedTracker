import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final db = DatabaseHelper.instance;

  List medications = [];
  List logs = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final meds = await db.getMedications();
    final todayLogs = await db.getTodayLogs();

    setState(() {
      medications = meds;
      logs = todayLogs;
    });
  }

  bool isTakenToday(int medId) {
    return logs.any((log) => log['medicationId'] == medId);
  }

  double getAdherence() {
    if (medications.isEmpty) return 0;

    int taken = medications.where((m) => isTakenToday(m['id'])).length;

    return taken / medications.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
      ),
      body: medications.isEmpty
          ? const Center(child: Text('No medications'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final med = medications[index];
                      final taken = isTakenToday(med['id']);

                      return ListTile(
                        leading: Icon(
                          taken ? Icons.check : Icons.close,
                          color: taken ? Colors.green : Colors.red,
                        ),
                        title: Text(med['name']),
                        subtitle: Text(med['dosage']),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Adherence: ${(getAdherence() * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
    );
  }
}