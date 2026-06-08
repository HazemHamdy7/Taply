class Category {
  final String id;
  final String name;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  Category copyWith({
    String? id,
    String? name,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isDefault': isDefault,
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as String,
        name: map['name'] as String,
        isDefault: map['isDefault'] as bool? ?? false,
      );
}
