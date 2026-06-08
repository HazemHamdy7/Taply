class Category {
  final String id;
  final String name;
  final bool isDefault;
  final String icon;
  final int color;
  final int sortOrder;

  const Category({
    required this.id,
    required this.name,
    this.isDefault = false,
    this.icon = 'label_outline',
    this.color = 0xFF9E9E9E,
    this.sortOrder = 0,
  });

  Category copyWith({
    String? id,
    String? name,
    bool? isDefault,
    String? icon,
    int? color,
    int? sortOrder,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isDefault': isDefault,
        'icon': icon,
        'color': color,
        'sortOrder': sortOrder,
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as String,
        name: map['name'] as String,
        isDefault: map['isDefault'] as bool? ?? false,
        icon: map['icon'] as String? ?? 'label_outline',
        color: map['color'] as int? ?? 0xFF9E9E9E,
        sortOrder: map['sortOrder'] as int? ?? 0,
      );
}
