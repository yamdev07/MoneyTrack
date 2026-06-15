import 'package:hive/hive.dart';

import 'savings_goal.dart';

/// Hand-written Hive adapter for [SavingsGoal].
class SavingsGoalAdapter extends TypeAdapter<SavingsGoal> {
  @override
  final int typeId = 4;

  @override
  SavingsGoal read(BinaryReader reader) {
    final count = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < count; i++) reader.readByte(): reader.read(),
    };
    return SavingsGoal(
      label: (fields[0] as String?) ?? 'Mon épargne',
      targetAmount: (fields[1] as num?)?.toDouble() ?? 0,
      savedAmount: (fields[2] as num?)?.toDouble() ?? 0,
      deadline: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsGoal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.targetAmount)
      ..writeByte(2)
      ..write(obj.savedAmount)
      ..writeByte(3)
      ..write(obj.deadline);
  }
}
