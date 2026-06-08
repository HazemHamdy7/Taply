import 'package:hive/hive.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_event.dart';

class AnalyticsEventModel {
  final String id;
  final String cardId;
  final String cardName;
  final String eventType;
  final DateTime timestamp;

  const AnalyticsEventModel({
    required this.id,
    required this.cardId,
    required this.cardName,
    required this.eventType,
    required this.timestamp,
  });

  factory AnalyticsEventModel.fromEntity(AnalyticsEvent entity) {
    return AnalyticsEventModel(
      id: entity.id,
      cardId: entity.cardId,
      cardName: entity.cardName,
      eventType: entity.eventType,
      timestamp: entity.timestamp,
    );
  }

  AnalyticsEvent toEntity() {
    return AnalyticsEvent(
      id: id,
      cardId: cardId,
      cardName: cardName,
      eventType: eventType,
      timestamp: timestamp,
    );
  }
}

class AnalyticsEventModelAdapter extends TypeAdapter<AnalyticsEventModel> {
  @override
  final int typeId = 3;

  @override
  AnalyticsEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsEventModel(
      id: (fields[0] as String?) ?? '',
      cardId: (fields[1] as String?) ?? '',
      cardName: (fields[2] as String?) ?? '',
      eventType: (fields[3] as String?) ?? '',
      timestamp: (fields[4] as DateTime?) ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsEventModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.cardName)
      ..writeByte(3)
      ..write(obj.eventType)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
