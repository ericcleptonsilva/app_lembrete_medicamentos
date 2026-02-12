import 'package:flutter_test/flutter_test.dart';
import 'package:medication_app/models/medication.dart';

void main() {
  test('Medication model serialization', () {
    final time = DateTime(2023, 10, 27, 10, 30);
    final medication = Medication(
      id: 1,
      name: 'Aspirin',
      dosage: '100mg',
      time: time,
    );

    final map = medication.toMap();
    expect(map['id'], 1);
    expect(map['name'], 'Aspirin');
    expect(map['dosage'], '100mg');
    expect(map['time'], time.toIso8601String());

    final newMedication = Medication.fromMap(map);
    expect(newMedication.id, 1);
    expect(newMedication.name, 'Aspirin');
    expect(newMedication.dosage, '100mg');
    expect(newMedication.time, time);
  });
}
