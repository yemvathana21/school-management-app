import 'user_model.dart';

class AnnouncementModel {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final String targetRole;
  final String createdAt;
  final UserModel? author;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    this.targetRole = 'all',
    required this.createdAt,
    this.author,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as int,
      targetRole: json['target_role'] as String? ?? 'all',
      createdAt: json['created_at'] as String,
      author: json['author'] != null
          ? UserModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }
}
