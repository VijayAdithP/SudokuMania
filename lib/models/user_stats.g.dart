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
      easyGamesStarted: fields[13] == null ? 0 : (fields[13] as num).toInt(),
      easyGamesWon: fields[14] == null ? 0 : (fields[14] as num).toInt(),
      easyWinRate: fields[15] == null ? 0.0 : (fields[15] as num).toDouble(),
      easyBestTime: fields[16] == null ? 0 : (fields[16] as num).toInt(),
      easyAvgTime: fields[17] == null ? 0 : (fields[17] as num).toInt(),
      mediumPoints: fields[9] == null ? 0 : (fields[9] as num).toInt(),
      mediumGamesStarted: fields[18] == null ? 0 : (fields[18] as num).toInt(),
      mediumGamesWon: fields[19] == null ? 0 : (fields[19] as num).toInt(),
      mediumWinRate: fields[20] == null ? 0.0 : (fields[20] as num).toDouble(),
      mediumBestTime: fields[21] == null ? 0 : (fields[21] as num).toInt(),
      mediumAvgTime: fields[22] == null ? 0 : (fields[22] as num).toInt(),
      hardPoints: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      hardGamesStarted: fields[23] == null ? 0 : (fields[23] as num).toInt(),
      hardGamesWon: fields[24] == null ? 0 : (fields[24] as num).toInt(),
      hardWinRate: fields[25] == null ? 0.0 : (fields[25] as num).toDouble(),
      hardBestTime: fields[26] == null ? 0 : (fields[26] as num).toInt(),
      hardAvgTime: fields[27] == null ? 0 : (fields[27] as num).toInt(),
      expertPoints: fields[11] == null ? 0 : (fields[11] as num).toInt(),
      expertGamesStarted: fields[28] == null ? 0 : (fields[28] as num).toInt(),
      expertGamesWon: fields[29] == null ? 0 : (fields[29] as num).toInt(),
      expertWinRate: fields[30] == null ? 0.0 : (fields[30] as num).toDouble(),
      expertBestTime: fields[31] == null ? 0 : (fields[31] as num).toInt(),
      expertAvgTime: fields[32] == null ? 0 : (fields[32] as num).toInt(),
      nightmarePoints: fields[12] == null ? 0 : (fields[12] as num).toInt(),
      nightmareGamesStarted:
          fields[33] == null ? 0 : (fields[33] as num).toInt(),
      nightmareGamesWon: fields[34] == null ? 0 : (fields[34] as num).toInt(),
      nightmareWinRate:
          fields[35] == null ? 0.0 : (fields[35] as num).toDouble(),
      nightmareBestTime: fields[36] == null ? 0 : (fields[36] as num).toInt(),
      nightmareAvgTime: fields[37] == null ? 0 : (fields[37] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer
      ..writeByte(38)
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
      ..write(obj.nightmarePoints)
      ..writeByte(13)
      ..write(obj.easyGamesStarted)
      ..writeByte(14)
      ..write(obj.easyGamesWon)
      ..writeByte(15)
      ..write(obj.easyWinRate)
      ..writeByte(16)
      ..write(obj.easyBestTime)
      ..writeByte(17)
      ..write(obj.easyAvgTime)
      ..writeByte(18)
      ..write(obj.mediumGamesStarted)
      ..writeByte(19)
      ..write(obj.mediumGamesWon)
      ..writeByte(20)
      ..write(obj.mediumWinRate)
      ..writeByte(21)
      ..write(obj.mediumBestTime)
      ..writeByte(22)
      ..write(obj.mediumAvgTime)
      ..writeByte(23)
      ..write(obj.hardGamesStarted)
      ..writeByte(24)
      ..write(obj.hardGamesWon)
      ..writeByte(25)
      ..write(obj.hardWinRate)
      ..writeByte(26)
      ..write(obj.hardBestTime)
      ..writeByte(27)
      ..write(obj.hardAvgTime)
      ..writeByte(28)
      ..write(obj.expertGamesStarted)
      ..writeByte(29)
      ..write(obj.expertGamesWon)
      ..writeByte(30)
      ..write(obj.expertWinRate)
      ..writeByte(31)
      ..write(obj.expertBestTime)
      ..writeByte(32)
      ..write(obj.expertAvgTime)
      ..writeByte(33)
      ..write(obj.nightmareGamesStarted)
      ..writeByte(34)
      ..write(obj.nightmareGamesWon)
      ..writeByte(35)
      ..write(obj.nightmareWinRate)
      ..writeByte(36)
      ..write(obj.nightmareBestTime)
      ..writeByte(37)
      ..write(obj.nightmareAvgTime);
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
