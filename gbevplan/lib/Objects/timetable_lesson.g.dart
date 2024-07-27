// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimetableLessonAdapter extends TypeAdapter<TimetableLesson> {
  @override
  final int typeId = 2;

  @override
  TimetableLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimetableLesson(
      coursename: fields[0] as String,
      raum: fields[1] as String,
      stunde: fields[2] as String,
      replacedFach: fields[3] as String,
      emptyEntry: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimetableLesson obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.coursename)
      ..writeByte(1)
      ..write(obj.raum)
      ..writeByte(2)
      ..write(obj.stunde)
      ..writeByte(3)
      ..write(obj.replacedFach)
      ..writeByte(4)
      ..write(obj.emptyEntry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimetableLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
