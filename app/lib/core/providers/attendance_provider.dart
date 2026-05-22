import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/attendance_model.dart';
import 'package:psbu_app/core/repositories/attendance_repository.dart';

final attendancesProvider = FutureProvider<List<AttendanceModel>>((ref) {
  return ref.read(attendanceRepositoryProvider).getAttendances();
});
