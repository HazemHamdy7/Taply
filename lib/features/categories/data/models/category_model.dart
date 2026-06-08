import 'package:hive/hive.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.isDefault,
  });

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      isDefault: entity.isDefault,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      isDefault: isDefault,
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
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault);
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
