class Medication {
  final int? id;
  final String name;
  final String dosage;
  final DateTime time;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time.toIso8601String(),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      time: DateTime.parse(map['time']),
    );
  }
}
