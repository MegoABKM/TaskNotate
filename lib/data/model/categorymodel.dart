class CategoryModel {
  final int? id;
  final String categoryName;

  CategoryModel({this.id, required this.categoryName});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      categoryName: map['categoryName'],
    );
  }
}
