import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/attendance_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.read(dioClientProvider));
});

class AttendanceRepository {
  final DioClient _client;
  AttendanceRepository(this._client);

  Future<List<AttendanceModel>> getAttendances() async {
    final response = await _client.dio.get('/attendances');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AttendanceModel> storeAttendance({
    required int scheduleId,
    required String qrCode,
  }) async {
    final response = await _client.dio.post('/attendances', data: {
      'schedule_id': scheduleId,
      'qr_code': qrCode,
    });
    return AttendanceModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateAttendance(int id, String status) async {
    await _client.dio.put('/attendances/$id', data: {'status': status});
  }
}
