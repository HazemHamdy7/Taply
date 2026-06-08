import 'package:hive/hive.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.isDefault,
    super.icon,
    super.color,
    super.sortOrder,
  });

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      isDefault: entity.isDefault,
      icon: entity.icon,
      color: entity.color,
      sortOrder: entity.sortOrder,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      isDefault: isDefault,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
    );
  }
}

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 2;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      id: (fields[0] as String?) ?? '',
      name: (fields[1] as String?) ?? '',
      isDefault: (fields[2] as bool?) ?? false,
      icon: (fields[3] as String?) ?? 'label_outline',
      color: (fields[4] as int?) ?? 0xFF9E9E9E,
      sortOrder: (fields[5] as int?) ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
