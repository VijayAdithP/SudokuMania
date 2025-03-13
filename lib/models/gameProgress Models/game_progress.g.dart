// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 5;

  @override
  GameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameProgress(
      boardState:
          (fields[0] as List).map((e) => (e as List).cast<int?>()).toList(),
      givenNumbers:
          (fields[1] as List).map((e) => (e as List).cast<bool>()).toList(),
      mistakes: (fields[2] as num).toInt(),
      elapsedTime: (fields[3] as num).toInt(),
      difficulty: fields[4] as String,
      isCompleted: fields[5] == null ? false : fields[5] as bool,
      lastPlayed: fields[6] as DateTime,
      invalidCells:
          (fields[7] as List?)?.map((e) => (e as List).cast<bool>()).toList(),
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.boardState)
      ..writeByte(1)
      ..write(obj.givenNumbers)
      ..writeByte(2)
      ..write(obj.mistakes)
      ..writeByte(3)
      ..write(obj.elapsedTime)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.lastPlayed)
      ..writeByte(7)
      ..write(obj.invalidCells);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
