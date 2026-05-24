import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_medication_screen.dart';

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
      ),

      body: medications.isEmpty
          ? const Center(
              child: Text('No medications yet'),
            )
          : ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];

                return ListTile(
                  title: Text(med['name']),
                  subtitle: Text(med['dosage']),
                  leading: const Icon(Icons.medication),
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