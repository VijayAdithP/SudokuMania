// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      userId: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String?,
      totalPoints: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      statistics: (fields[4] as Map?)?.cast<String, DifficultyStats>(),
      gameHistory: (fields[5] as List?)?.cast<GameHistory>(),
      currentGame: fields[6] as CurrentGameProgress?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.totalPoints)
      ..writeByte(4)
      ..write(obj.statistics)
      ..writeByte(5)
      ..write(obj.gameHistory)
      ..writeByte(6)
      ..write(obj.currentGame);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyStatsAdapter extends TypeAdapter<DifficultyStats> {
  @override
  final int typeId = 1;

  @override
  DifficultyStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DifficultyStats(
      gamesStarted: fields[0] == null ? 0 : (fields[0] as num).toInt(),
      gamesWon: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      winRate: fields[2] == null ? 0.0 : (fields[2] as num).toDouble(),
      bestTime: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      avgTime: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      currentStreak: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      longestStreak: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      points: fields[7] == null ? 0 : (fields[7] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DifficultyStats obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.longestStreak)
      ..writeByte(7)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameHistoryAdapter extends TypeAdapter<GameHistory> {
  @override
  final int typeId = 2;

  @override
  GameHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameHistory(
      gameId: fields[0] as String,
      difficulty: fields[1] as String,
      timeTaken: (fields[2] as num).toInt(),
      mistakes: (fields[3] as num).toInt(),
      completionDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.timeTaken)
      ..writeByte(3)
      ..write(obj.mistakes)
      ..writeByte(4)
      ..write(obj.completionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentGameProgressAdapter extends TypeAdapter<CurrentGameProgress> {
  @override
  final int typeId = 3;

  @override
  CurrentGameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentGameProgress(
      boardState:
          (fields[0] as List).map((e) => (e as List).cast<int?>()).toList(),
      givenNumbers:
          (fields[1] as List).map((e) => (e as List).cast<bool>()).toList(),
      mistakes: (fields[2] as num).toInt(),
      elapsedTime: (fields[3] as num).toInt(),
      difficulty: fields[4] as String,
      lastSaved: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentGameProgress obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.lastSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentGameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
