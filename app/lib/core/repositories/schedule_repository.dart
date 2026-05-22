import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.read(dioClientProvider));
});

class ScheduleRepository {
  final DioClient _client;
  ScheduleRepository(this._client);

  Future<List<ScheduleModel>> getSchedules() async {
    final response = await _client.dio.get('/schedules');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
