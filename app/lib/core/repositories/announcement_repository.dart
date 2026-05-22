import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/announcement_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository(ref.read(dioClientProvider));
});

class AnnouncementRepository {
  final DioClient _client;
  AnnouncementRepository(this._client);

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await _client.dio.get('/announcements');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
