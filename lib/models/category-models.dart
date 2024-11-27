// ignore_for_file: file_names
class LearningCategory {
 final String categoryId;
  final String name;
  final String icon;
  final double score;
  final List levels;

  LearningCategory({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.score,
    required this.levels,
  });

  // Serialize the LearningCategory instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
     'categoryId': categoryId,
      'name': name,
      'icon': icon,
      'score': score,
      'levels': levels,
    };
  }

  // Create a LearningCategory instance from a JSON map
  factory LearningCategory.fromMap(Map<String, dynamic> json) {
    return LearningCategory(
      categoryId: json['categoryId'],
      name: json['name'],
      icon: json['icon'],
      score: json['score'],
      levels: json['levels'],
    );
  }
}
