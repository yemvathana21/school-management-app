import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/assignment_model.dart';
import 'package:psbu_app/core/repositories/assignment_repository.dart';

final assignmentsProvider = FutureProvider<List<AssignmentModel>>((ref) {
  return ref.read(assignmentRepositoryProvider).getAssignments();
});
