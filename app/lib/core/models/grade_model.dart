import 'course_model.dart';
import 'user_model.dart';

class GradeModel {
  final int id;
  final int studentId;
  final int courseId;
  final int teacherId;
  final String type;
  final String name;
  final double score;
  final double maxScore;
  final String? note;
  final CourseModel? course;
  final UserModel? student;
  final UserModel? teacher;

  GradeModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.teacherId,
    required this.type,
    required this.name,
    required this.score,
    this.maxScore = 100,
    this.note,
    this.course,
    this.student,
    this.teacher,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      courseId: json['course_id'] as int,
      teacherId: json['teacher_id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      score: (json['score'] as num).toDouble(),
      maxScore: (json['max_score'] as num?)?.toDouble() ?? 100,
      note: json['note'] as String?,
      course: json['course'] != null
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      student: json['student'] != null
          ? UserModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] != null
          ? UserModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }

  double get percentage => (score / maxScore) * 100;
}


