// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_weekday.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimetableWeekdayAdapter extends TypeAdapter<TimetableWeekday> {
  @override
  final int typeId = 1;

  @override
  TimetableWeekday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimetableWeekday(
      dailytimetable: (fields[0] as List).cast<TimetableLesson>(),
      dayofweek: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimetableWeekday obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dailytimetable)
      ..writeByte(1)
      ..write(obj.dayofweek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimetableWeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
