// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sudoku_board.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SudokuBoardAdapter extends TypeAdapter<SudokuBoard> {
  @override
  final int typeId = 4;

  @override
  SudokuBoard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SudokuBoard(
      grid: (fields[0] as List).map((e) => (e as List).cast<int?>()).toList(),
      givenNumbers:
          (fields[1] as List).map((e) => (e as List).cast<bool>()).toList(),
      mistakes: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      maxMistakes: (fields[3] as num).toInt(),
      gameOver: fields[4] == null ? false : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SudokuBoard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.grid)
      ..writeByte(1)
      ..write(obj.givenNumbers)
      ..writeByte(2)
      ..write(obj.mistakes)
      ..writeByte(3)
      ..write(obj.maxMistakes)
      ..writeByte(4)
      ..write(obj.gameOver);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SudokuBoardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
