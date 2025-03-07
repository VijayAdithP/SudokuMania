// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cred.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCredAdapter extends TypeAdapter<UserCred> {
  @override
  final int typeId = 11;

  @override
  UserCred read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCred(
      uid: fields[0] as String,
      email: fields[1] as String?,
      displayName: fields[2] as String?,
      photoURL: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      emailVerified: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserCred obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoURL)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.emailVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCredAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
