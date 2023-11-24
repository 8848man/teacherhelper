import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/lesson.dart';
import 'package:teacherhelper/datamodels/new_daily.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/datamodels/structured_history_data.dart';

class StructuredClassroomData {
  Classroom? classroom;
  List<NewStudent>? students;
  List<NewDaily>? dailys;
  List<Lesson>? lessons;
  List<StructuredHistoryData>? structuredHistoryData;

  StructuredClassroomData({
    this.classroom,
    this.students,
    this.dailys,
    this.lessons,
    this.structuredHistoryData,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom': classroom?.toJson(),
      'students': students?.map((student) => student.toJson()).toList(),
      'dailys': dailys?.map((daily) => daily.toJson()).toList(),
      'lessons': lessons?.map((lesson) => lesson.toJson()).toList(),
      'structuredHistoryData':
          structuredHistoryData?.map((data) => data.toJson()).toList(),
    };
  }

  factory StructuredClassroomData.fromJson(Map<String, dynamic> json) {
    return StructuredClassroomData(
      classroom: Classroom.fromJson(json['classroom']),
      students: (json['students'] as List<dynamic>)
          .map((studentJson) =>
              NewStudent.fromJson(studentJson as Map<String, dynamic>))
          .toList(),
      dailys: (json['dailys'] as List<dynamic>?)
          ?.map((dailyJson) =>
              NewDaily.fromJson(dailyJson as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lessonJson) =>
              Lesson.fromJson(lessonJson as Map<String, dynamic>))
          .toList(),
      structuredHistoryData: (json['structuredHistoryData'] as List<dynamic>?)
          ?.map((dataJson) =>
              StructuredHistoryData.fromJson(dataJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
