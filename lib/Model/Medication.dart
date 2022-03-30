class Medication {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  String description;
  String? recurrenceRule;
  final String amount;

  Medication({
    required this.name,
    required this.startTime,
    required this.endTime,
    this.description = "",
    this.recurrenceRule,
    required this.amount,
  });


}
