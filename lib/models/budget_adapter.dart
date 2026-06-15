import 'package:hive/hive.dart';

import 'budget.dart';

/// Hand-written Hive adapter for [Budget].
class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 3;

  @override
  Budget read(BinaryReader reader) {
    final count = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < count; i++) reader.readByte(): reader.read(),
    };
    final raw = (fields[0] as Map?) ?? const {};
    return Budget(
      percentages: raw.map(
        (key, value) => MapEntry(key as int, (value as num).toDouble()),
      ),
      savingsPercent: (fields[1] as num?)?.toDouble() ?? 10,
      weeklyBudget: (fields[2] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.percentages)
      ..writeByte(1)
      ..write(obj.savingsPercent)
      ..writeByte(2)
      ..write(obj.weeklyBudget);
  }
}
