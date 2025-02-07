// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 6;

  @override
  UserStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStats(
      gamesStarted: fields[0] == null ? 0 : (fields[0] as num).toInt(),
      gamesWon: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      winRate: fields[2] == null ? 0.0 : (fields[2] as num).toDouble(),
      bestTime: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      avgTime: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      currentWinStreak: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      longestWinStreak: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      totalPoints: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      easyPoints: fields[8] == null ? 0 : (fields[8] as num).toInt(),
      mediumPoints: fields[9] == null ? 0 : (fields[9] as num).toInt(),
      hardPoints: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      expertPoints: fields[11] == null ? 0 : (fields[11] as num).toInt(),
      nightmarePoints: fields[12] == null ? 0 : (fields[12] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.gamesStarted)
      ..writeByte(1)
      ..write(obj.gamesWon)
      ..writeByte(2)
      ..write(obj.winRate)
      ..writeByte(3)
      ..write(obj.bestTime)
      ..writeByte(4)
      ..write(obj.avgTime)
      ..writeByte(5)
      ..write(obj.currentWinStreak)
      ..writeByte(6)
      ..write(obj.longestWinStreak)
      ..writeByte(7)
      ..write(obj.totalPoints)
      ..writeByte(8)
      ..write(obj.easyPoints)
      ..writeByte(9)
      ..write(obj.mediumPoints)
      ..writeByte(10)
      ..write(obj.hardPoints)
      ..writeByte(11)
      ..write(obj.expertPoints)
      ..writeByte(12)
      ..write(obj.nightmarePoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
