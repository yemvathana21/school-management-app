class CourseModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final int credits;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.credits = 0,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      credits: json['credits'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'description': description,
        'credits': credits,
      };
}
