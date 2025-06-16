class UserTasksModel {
  final String? id;
  final String? title;
  final String? content;
  final String? date;
  final String? estimatetime;
  final String? reminder;
  final String? status;
  String? priority;
  final String? subtask;
  final String? category;
  final String? checked;
  final String? images;
  final String? timeline;
  final String? starttime;

  UserTasksModel({
    this.id,
    this.title,
    this.content,
    this.date,
    this.estimatetime,
    this.reminder,
    this.status,
    this.priority,
    this.subtask,
    this.category,
    this.checked,
    this.images,
    this.timeline,
    this.starttime,
  });

  factory UserTasksModel.fromJson(Map<String, dynamic> json) {
    return UserTasksModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      date: json['date']?.toString(),
      estimatetime: json['estimatetime']?.toString(),
      reminder: json['reminder']?.toString(),
      status: json['status']?.toString(),
      priority: json['priority']?.toString(),
      subtask: json['subtask']?.toString(),
      category: json['categoryId']?.toString() ?? "Home",
      checked: json['checked']?.toString(),
      images: json['images']?.toString(),
      timeline: json['timeline']?.toString(),
      starttime: json['starttime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'estimatetime': estimatetime,
      'reminder': reminder,
      'status': status,
      'priority': priority,
      'subtask': subtask,
      'categoryId': category,
      'checked': checked,
      'images': images,
      'timeline': timeline,
      'starttime': starttime,
    };
  }

  UserTasksModel copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? estimatetime,
    String? reminder,
    String? status,
    String? priority,
    String? subtask,
    String? category,
    String? checked,
    String? images,
    String? timeline,
    String? starttime,
  }) {
    return UserTasksModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      estimatetime: estimatetime ?? this.estimatetime,
      reminder: reminder ?? this.reminder,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      subtask: subtask ?? this.subtask,
      category: category ?? this.category,
      checked: checked ?? this.checked,
      images: images ?? this.images,
      timeline: timeline ?? this.timeline,
      starttime: starttime ?? this.starttime,
    );
  }
}
