import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_medication_screen.dart';
import 'history_screen.dart';
import 'today_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper.instance;

  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    loadMedications();
  }

  void loadMedications() async {
    final data = await db.getMedications();
    setState(() {
      medications = data;
    });
  }

  void goToAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationScreen(),
      ),
    );

    loadMedications(); // refresh after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TodayScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: medications.isEmpty
          ? const Center(
              child: Text('No medications yet'),
            )
          : ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.medication),
                    title: Text(med['name']),
                    subtitle: Text(med['dosage']),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await db.addLog(med['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Marked as taken'),
                          ),
                        );
                      },
                      child: const Text('Taken'),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: goToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}