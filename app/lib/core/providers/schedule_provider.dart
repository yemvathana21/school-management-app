import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/repositories/schedule_repository.dart';

final schedulesProvider = FutureProvider<List<ScheduleModel>>((ref) {
  return ref.read(scheduleRepositoryProvider).getSchedules();
});
