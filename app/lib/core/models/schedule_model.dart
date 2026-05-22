import 'course_model.dart';
import 'user_model.dart';

class ClassModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final int? teacherId;
  final UserModel? teacher;
  final List<UserModel>? students;
  final List<ScheduleModel>? schedules;

  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.teacherId,
    this.teacher,
    this.students,
    this.schedules,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      teacherId: json['teacher_id'] as int?,
      teacher: json['teacher'] != null
          ? UserModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScheduleModel {
  final int id;
  final int classId;
  final int courseId;
  final int teacherId;
  final String day;
  final String startTime;
  final String endTime;
  final String? room;
  final ClassModel? class_;
  final CourseModel? course;
  final UserModel? teacher;

  ScheduleModel({
    required this.id,
    required this.classId,
    required this.courseId,
    required this.teacherId,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.room,
    this.class_,
    this.course,
    this.teacher,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      courseId: json['course_id'] as int,
      teacherId: json['teacher_id'] as int,
      day: json['day'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      room: json['room'] as String?,
      class_: json['class'] != null
          ? ClassModel.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      course: json['course'] != null
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] != null
          ? UserModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }
}
