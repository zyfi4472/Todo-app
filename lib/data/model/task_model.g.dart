// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      name: json['name'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] as String,
      priority: json['priority'] as String,
      isDone: json['isDone'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'priority': instance.priority,
      'deadline': instance.deadline,
      'isDone': instance.isDone,
    };
