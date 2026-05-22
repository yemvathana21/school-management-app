import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/repositories/class_repository.dart';

final classesProvider = FutureProvider<List<ClassModel>>((ref) {
  return ref.read(classRepositoryProvider).getClasses();
});
