import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final qrRepositoryProvider = Provider<QrRepository>((ref) {
  return QrRepository(ref.read(dioClientProvider));
});

class QrRepository {
  final DioClient _client;
  QrRepository(this._client);

  Future<Map<String, dynamic>> generateQr(int scheduleId) async {
    final response = await _client.dio.post('/qr/generate', data: {
      'schedule_id': scheduleId,
    });
    return response.data as Map<String, dynamic>;
  }
}
