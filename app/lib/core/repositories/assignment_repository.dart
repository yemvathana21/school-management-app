import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/assignment_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final assignmentRepositoryProvider = Provider<AssignmentRepository>((ref) {
  return AssignmentRepository(ref.read(dioClientProvider));
});

class AssignmentRepository {
  final DioClient _client;
  AssignmentRepository(this._client);

  Future<List<AssignmentModel>> getAssignments() async {
    final response = await _client.dio.get('/assignments');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
