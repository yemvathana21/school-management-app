import 'course_model.dart';
import 'schedule_model.dart';
import 'user_model.dart';

class AssignmentModel {
  final int id;
  final int classId;
  final int courseId;
  final int teacherId;
  final String title;
  final String? description;
  final String dueDate;
  final String? fileUrl;
  final ClassModel? class_;
  final CourseModel? course;
  final UserModel? teacher;

  AssignmentModel({
    required this.id,
    required this.classId,
    required this.courseId,
    required this.teacherId,
    required this.title,
    this.description,
    required this.dueDate,
    this.fileUrl,
    this.class_,
    this.course,
    this.teacher,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      courseId: json['course_id'] as int,
      teacherId: json['teacher_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] as String,
      fileUrl: json['file_url'] as String?,
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

  bool get isOverdue {
    final due = DateTime.tryParse(dueDate);
    if (due == null) return false;
    return due.isBefore(DateTime.now());
  }
}
