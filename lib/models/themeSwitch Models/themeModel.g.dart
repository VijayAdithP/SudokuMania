// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themeModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemePreferenceAdapter extends TypeAdapter<ThemePreference> {
  @override
  final int typeId = 50;

  @override
  ThemePreference read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemePreference.light;
      case 1:
        return ThemePreference.dark;
      default:
        return ThemePreference.light;
    }
  }

  @override
  void write(BinaryWriter writer, ThemePreference obj) {
    switch (obj) {
      case ThemePreference.light:
        writer.writeByte(0);
      case ThemePreference.dark:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
