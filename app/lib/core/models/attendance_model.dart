import 'schedule_model.dart';
import 'user_model.dart';

class AttendanceModel {
  final int id;
  final int scheduleId;
  final int studentId;
  final int teacherId;
  final String date;
  final String status;
  final String? note;
  final String? qrCode;
  final ScheduleModel? schedule;
  final UserModel? student;
  final UserModel? teacher;

  AttendanceModel({
    required this.id,
    required this.scheduleId,
    required this.studentId,
    required this.teacherId,
    required this.date,
    required this.status,
    this.note,
    this.qrCode,
    this.schedule,
    this.student,
    this.teacher,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      scheduleId: json['schedule_id'] as int,
      studentId: json['student_id'] as int,
      teacherId: json['teacher_id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
      qrCode: json['qr_code'] as String?,
      schedule: json['schedule'] != null
          ? ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>)
          : null,
      student: json['student'] != null
          ? UserModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] != null
          ? UserModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }
}
