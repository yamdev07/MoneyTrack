import 'package:hive/hive.dart';

import 'user_profile.dart';

/// Hand-written Hive adapter for [UserProfile].
class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 2;

  @override
  UserProfile read(BinaryReader reader) {
    final count = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < count; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: (fields[0] as String?) ?? '',
      monthlySalary: (fields[1] as num?)?.toDouble() ?? 0,
      currencyCode: (fields[2] as String?) ?? 'FCFA',
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.monthlySalary)
      ..writeByte(2)
      ..write(obj.currencyCode);
  }
}
