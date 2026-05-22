import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/grade_model.dart';
import 'package:psbu_app/core/repositories/grade_repository.dart';

final gradesProvider = FutureProvider<List<GradeModel>>((ref) {
  return ref.read(gradeRepositoryProvider).getGrades();
});
