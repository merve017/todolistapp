import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Todo {
  @JsonKey(name: 'uid')
  String? uid;

  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "priority", defaultValue: 1)
  int? priority;

  @JsonKey(name: "status", defaultValue: false)
  bool? status;

  @JsonKey(name: "done_date")
  DateTime? doneDate;

  @JsonKey(name: "due_date")
  DateTime? dueDate;

  @JsonKey(name: "rid", defaultValue: null)
  String? rid;

  Todo(
      {this.uid,
      required this.title,
      this.description,
      required this.priority,
      this.rid,
      this.status,
      this.dueDate,
      this.doneDate});

  factory Todo.fromMap(map) {
    return Todo(
        uid: map['uuid'],
        title: map['todo_Title'],
        description: map['description'],
        priority: map['priority'],
        status: map['status'],
        rid: map['rid'],
        dueDate: map['due_date'],
        doneDate: map['doneDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'todoTitle': title,
      'status': status,
      'description': description,
      'priority': priority,
      'rid': rid,
      'due_date': dueDate,
      'done_date': doneDate
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      priority: json['priority'] as int? ?? 1,
      status: json['status'] as bool? ?? false,
      dueDate: json['due_date'] == null
          ? null
          : json['due_date'].toDate() == DateTime(2000, 1, 1)
              ? null
              : json['due_date'].toDate() as DateTime,
      doneDate: json['done_date'] == null
          ? null
          : json['done_date'].toDate() as DateTime?,
      rid: json['rid'] == null ? null : json['rid'] as String,
    );
  }

  Map<String, dynamic> toJson(Todo instance) => <String, dynamic>{
        'uid': instance.uid,
        'title': instance.title,
        'status': status ?? false,
        'description': description,
        'priority': priority,
        'rid': rid,
        'due_date': dueDate ?? DateTime(2000, 1, 1),
        'done_date': doneDate
      };
}
