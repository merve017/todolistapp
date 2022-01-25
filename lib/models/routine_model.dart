import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RoutineTask {
  @JsonKey(name: 'rid')
  String? rid;

  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "priority", defaultValue: 1)
  int? priority;

  @JsonKey(name: "start_date")
  DateTime? startDate;

  @JsonKey(name: "due_date")
  DateTime? dueDate;

  @JsonKey(name: "weekdays")
  List<bool> weekdays;

  @JsonKey(name: "repetition")
  int? repetition;

  RoutineTask(
      {this.rid,
      required this.title,
      this.description,
      required this.priority,
      this.dueDate,
      this.startDate,
      this.repetition,
      required this.weekdays});

  factory RoutineTask.fromMap(map) {
    return RoutineTask(
        rid: map['uuid'],
        title: map['todo_Title'],
        description: map['description'],
        priority: map['priority'],
        dueDate: map['due_date'],
        startDate: map['startDate'],
        weekdays: map['weekdays'],
        repetition: map['repetition']);
  }

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'todoTitle': title,
      'description': description,
      'priority': priority,
      'due_date': dueDate,
      'startDate': startDate,
      'weekdays': weekdays,
      'repetition': repetition,
    };
  }

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
        rid: json['rid'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        priority: json['priority'] as int? ?? 1,
        dueDate: json['due_date'] == null
            ? null
            : json['due_date'].toDate() as DateTime?,
        startDate: json['start_date'] == null
            ? null
            : json['start_date'].toDate() as DateTime?,
        weekdays: json['weekdays'] == null
            ? List<bool>.filled(7, false)
            : (json['weekdays'].cast<bool>()),
        repetition: json['repetition'] == null ? 0 : json['repetition'] as int);
  }

  Map<String, dynamic> toJson(RoutineTask instance) => <String, dynamic>{
        'rid': instance.rid,
        'title': instance.title,
        'description': description,
        'priority': priority,
        'due_date': dueDate,
        'start_date': startDate,
        'weekdays': weekdays,
        'repetition': repetition
      };

  List<bool> weekdaysfromJson(data) {
    for (var i = 0; i < 7; i++) {
      weekdays[i] = data[i] as bool;
    }
    return weekdays;
  }
}
