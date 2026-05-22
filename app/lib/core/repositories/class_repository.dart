import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepository(ref.read(dioClientProvider));
});

class ClassRepository {
  final DioClient _client;
  ClassRepository(this._client);

  Future<List<ClassModel>> getClasses() async {
    final response = await _client.dio.get('/classes');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ClassModel> getClass(int id) async {
    final response = await _client.dio.get('/classes/$id');
    return ClassModel.fromJson(response.data as Map<String, dynamic>);
  }
}
