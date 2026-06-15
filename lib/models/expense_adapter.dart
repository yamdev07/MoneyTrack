import 'package:hive/hive.dart';

import 'expense.dart';

/// Hand-written Hive adapter for [Expense] (avoids build_runner codegen).
class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 1;

  @override
  Expense read(BinaryReader reader) {
    final count = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < count; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      amount: fields[1] as double,
      categoryId: fields[2] as int,
      date: fields[3] as DateTime,
      description: (fields[4] as String?) ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.description);
  }
}
