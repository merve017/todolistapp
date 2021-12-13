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

  Todo(
      {this.uid,
      required this.title,
      this.description,
      this.priority,
      this.status});

  factory Todo.fromMap(map) {
    return Todo(
        uid: map['uuid'],
        title: map['todo_Title'],
        description: map['description'],
        priority: map['priority'],
        status: map['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'todoTitle': title,
      'status': status,
      'description': description,
      'priority': priority,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        uid: json['uid'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        priority: json['priority'] as int? ?? 5,
        status: json['status'] as bool? ?? false);
  }

  Map<String, dynamic> toJson(Todo instance) => <String, dynamic>{
        'uid': instance.uid,
        'title': instance.title,
        'status': status,
        'description': description,
        'priority': priority,
      };
}
