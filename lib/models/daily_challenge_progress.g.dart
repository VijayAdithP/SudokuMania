// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyChallengeProgressAdapter
    extends TypeAdapter<DailyChallengeProgress> {
  @override
  final int typeId = 7;

  @override
  DailyChallengeProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyChallengeProgress(
      completedDays: (fields[0] as Map).cast<DateTime, bool>(),
      multiplier: fields[1] == null ? 1.0 : (fields[1] as num).toDouble(),
      completedCount: fields[2] == null ? 0 : (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyChallengeProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.completedDays)
      ..writeByte(1)
      ..write(obj.multiplier)
      ..writeByte(2)
      ..write(obj.completedCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyChallengeProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
