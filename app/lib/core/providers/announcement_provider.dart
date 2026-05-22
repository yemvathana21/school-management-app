import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/announcement_model.dart';
import 'package:psbu_app/core/repositories/announcement_repository.dart';

final announcementsProvider = FutureProvider<List<AnnouncementModel>>((ref) {
  return ref.read(announcementRepositoryProvider).getAnnouncements();
});
