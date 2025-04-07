import 'dart:convert';

class Habit {
  final int? id;
  final String name;
  final DateTime startDate;
  final List<DateTime> checkedDays;

  const Habit({this.id, required this.name, required this.startDate, this.checkedDays = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'checkedDays': jsonEncode(checkedDays.map((day) => day.toIso8601String()).toList()),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      checkedDays: (jsonDecode(map['checkedDays']) as List<dynamic>)
          .map(
            (day) => DateTime.parse(day as String),
          )
          .toList(),
    );
  }

  Habit copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    List<DateTime>? checkedDays,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      checkedDays: checkedDays ?? this.checkedDays,
    );
  }

  @override
  @override
  String toString() {
    return 'Habit{id: $id, startDate: ${startDate.toIso8601String()}, name: $name,'
        ' checkedDays: $checkedDays';
  }
}
