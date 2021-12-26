import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Todo {
  @JsonKey(name: 'uid')
  String? uid;

  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "priority", defaultValue: 5)
  int? priority;

  @JsonKey(name: "status", defaultValue: false)
  bool? status;

  @JsonKey(name: "due_date")
  DateTime? dueDate;

  @JsonKey(name: "routine", defaultValue: false)
  bool? routine;

  @JsonKey(name: "weekdays")
  List<bool> weekdays;

  Todo(
      {this.uid,
      required this.title,
      this.description,
      required this.priority,
      this.status,
      this.routine,
      this.dueDate,
      required this.weekdays});

  factory Todo.fromMap(map) {
    return Todo(
      uid: map['uuid'],
      title: map['todo_Title'],
      description: map['description'],
      priority: map['priority'],
      status: map['status'],
      routine: map['routine'],
      dueDate: map['due_date'],
      weekdays: map['weekdays'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'todoTitle': title,
      'status': status,
      'description': description,
      'priority': priority,
      'routine': routine,
      'due_date': dueDate,
      'weekdays': weekdays
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        uid: json['uid'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        priority: json['priority'] as int? ?? 5,
        status: json['status'] as bool? ?? false,
        dueDate: json['due_date'] == null
            ? null
            : json['due_date'].toDate() as DateTime?,
        routine: json['routine'] as bool? ?? false,
        weekdays: json['weekdays'] == null
            ? List<bool>.filled(7, false)
            : (json['weekdays'].cast<bool>()));
  }

  Map<String, dynamic> toJson(Todo instance) => <String, dynamic>{
        'uid': instance.uid,
        'title': instance.title,
        'status': status,
        'description': description,
        'priority': priority,
        'routine': routine,
        'due_date': dueDate,
        'weekdays': weekdays
      };

  List<bool> weekdaysfromJson(data) {
    for (var i = 0; i < 7; i++) {
      weekdays[i] = data[i] as bool;
    }
    return weekdays;
  }
}
