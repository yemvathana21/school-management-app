import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/grade_model.dart';
import 'package:psbu_app/core/network/dio_client.dart';

final gradeRepositoryProvider = Provider<GradeRepository>((ref) {
  return GradeRepository(ref.read(dioClientProvider));
});

class GradeRepository {
  final DioClient _client;
  GradeRepository(this._client);

  Future<List<GradeModel>> getGrades() async {
    final response = await _client.dio.get('/grades');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => GradeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GradeModel> storeGrade({
    required int studentId,
    required int courseId,
    required String type,
    required String name,
    required double score,
    required double maxScore,
    String? note,
  }) async {
    final response = await _client.dio.post('/grades', data: {
      'student_id': studentId,
      'course_id': courseId,
      'type': type,
      'name': name,
      'score': score,
      'max_score': maxScore,
      'note': note,
    });
    return GradeModel.fromJson(response.data as Map<String, dynamic>);
  }
}
