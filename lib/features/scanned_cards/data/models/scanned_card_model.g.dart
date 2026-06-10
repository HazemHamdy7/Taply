// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScannedCardModelAdapter extends TypeAdapter<ScannedCardModel> {
  @override
  final int typeId = 1;

  @override
  ScannedCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScannedCardModel(
      id: fields[0] as String,
      cardId: fields[22] as String,
      fullName: fields[1] as String,
      jobTitle: fields[2] as String,
      companyName: fields[3] as String,
      tagline: fields[4] as String,
      mobileNumber: fields[5] as String,
      whatsappNumber: fields[6] as String,
      email: fields[7] as String,
      website: fields[8] as String,
      linkedin: fields[9] as String,
      facebook: fields[10] as String,
      instagram: fields[11] as String,
      telegram: fields[12] as String,
      youtube: fields[13] as String,
      x: fields[14] as String,
      address: fields[15] as String,
      aboutMe: fields[16] as String,
      templateId: fields[17] as String,
      profileImagePath: fields[18] as String?,
      scanDate: fields[19] as DateTime,
      isFavorite: fields[20] as bool,
      mobileNumber2: fields[21] as String,
      categoryIds: (fields[23] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScannedCardModel obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.companyName)
      ..writeByte(4)
      ..write(obj.tagline)
      ..writeByte(5)
      ..write(obj.mobileNumber)
      ..writeByte(6)
      ..write(obj.whatsappNumber)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.website)
      ..writeByte(9)
      ..write(obj.linkedin)
      ..writeByte(10)
      ..write(obj.facebook)
      ..writeByte(11)
      ..write(obj.instagram)
      ..writeByte(12)
      ..write(obj.telegram)
      ..writeByte(13)
      ..write(obj.youtube)
      ..writeByte(14)
      ..write(obj.x)
      ..writeByte(15)
      ..write(obj.address)
      ..writeByte(16)
      ..write(obj.aboutMe)
      ..writeByte(17)
      ..write(obj.templateId)
      ..writeByte(18)
      ..write(obj.profileImagePath)
      ..writeByte(19)
      ..write(obj.scanDate)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(21)
      ..write(obj.mobileNumber2)
      ..writeByte(22)
      ..write(obj.cardId)
      ..writeByte(23)
      ..write(obj.categoryIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
