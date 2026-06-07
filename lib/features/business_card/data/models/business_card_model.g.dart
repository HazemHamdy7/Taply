// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessCardModelAdapter extends TypeAdapter<BusinessCardModel> {
  @override
  final int typeId = 0;

  @override
  BusinessCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessCardModel(
      id: fields[0] as String?,
      profileImagePath: fields[1] as String?,
      fullName: fields[2] as String,
      jobTitle: fields[3] as String,
      companyName: fields[4] as String,
      mobileNumber: fields[5] as String,
      whatsappNumber: fields[6] as String,
      email: fields[7] as String,
      website: fields[8] as String,
      linkedin: fields[9] as String,
      facebook: fields[10] as String,
      instagram: fields[11] as String,
      telegram: fields[12] as String,
      address: fields[13] as String,
      aboutMe: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessCardModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileImagePath)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.jobTitle)
      ..writeByte(4)
      ..write(obj.companyName)
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
      ..write(obj.address)
      ..writeByte(14)
      ..write(obj.aboutMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
