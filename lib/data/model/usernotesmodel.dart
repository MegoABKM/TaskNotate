class UserNotesModel {
  final String? id;
  final String? title;
  final String? content;
  final String? date;
  final String? drawing;
  final String? categoryId;

  UserNotesModel({
    this.id,
    this.title,
    this.content,
    this.date,
    this.drawing,
    this.categoryId,
  });

  factory UserNotesModel.fromJson(Map<String, dynamic> json) {
    return UserNotesModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      date: json['date']?.toString(),
      drawing: json['drawing']?.toString(),
      categoryId: json['categoryId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'drawing': drawing,
      'categoryId': categoryId,
    };
  }

  UserNotesModel copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? drawing,
    String? categoryId,
  }) {
    return UserNotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      drawing: drawing ?? this.drawing,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
