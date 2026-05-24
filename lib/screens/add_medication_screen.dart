import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  final db = DatabaseHelper.instance;

  void saveMedication() async {
    String name = nameController.text.trim();
    String dosage = dosageController.text.trim();

    if (name.isEmpty || dosage.isEmpty) return;

    await db.insertMedication({
      'name': name,
      'dosage': dosage,
    });

    Navigator.pop(context); // go back to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage',
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveMedication,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}