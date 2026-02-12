import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medication.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import 'add_medication_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _refreshMedications();
  }

  void _refreshMedications() {
    setState(() {
      _medications = DatabaseHelper().getMedications();
    });
  }

  Future<void> _deleteMedication(Medication medication) async {
    await DatabaseHelper().deleteMedication(medication.id!);
    await NotificationService().cancelNotification(medication.id!);
    _refreshMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminders'),
      ),
      body: FutureBuilder<List<Medication>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No medications added yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final medication = snapshot.data![index];
              final timeFormat = DateFormat.jm();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(medication.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${medication.dosage} - ${timeFormat.format(medication.time)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMedication(medication),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
          );
          if (result == true) {
            _refreshMedications();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
