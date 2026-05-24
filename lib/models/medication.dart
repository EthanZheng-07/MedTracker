class Medication {
  final int? id;
  final String name;
  final String dosage;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
    );
  }
}