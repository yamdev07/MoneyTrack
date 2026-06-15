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

    // Field 3 used to be a `weeklyRollover` bool; field 4 is the newer
    // surplusMode enum. Fall back gracefully when reading old records.
    final legacyRollover = (fields[3] as bool?) ?? false;
    final modeIndex = fields[4] as int?;
    final mode = modeIndex != null
        ? WeeklySurplusMode.values[modeIndex]
        : (legacyRollover ? WeeklySurplusMode.rollover : WeeklySurplusMode.none);

    return Budget(
      percentages: raw.map(
        (key, value) => MapEntry(key as int, (value as num).toDouble()),
      ),
      savingsPercent: (fields[1] as num?)?.toDouble() ?? 10,
      weeklyBudget: (fields[2] as num?)?.toDouble() ?? 0,
      surplusMode: mode,
      lastSweepWeekStart: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.percentages)
      ..writeByte(1)
      ..write(obj.savingsPercent)
      ..writeByte(2)
      ..write(obj.weeklyBudget)
      // Keep field 3 in sync for backward compatibility with old readers.
      ..writeByte(3)
      ..write(obj.isRollover)
      ..writeByte(4)
      ..write(obj.surplusMode.index)
      ..writeByte(5)
      ..write(obj.lastSweepWeekStart);
  }
}
