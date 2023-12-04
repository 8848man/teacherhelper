import 'package:teacherhelper/models/classroom_model.dart';

abstract class ClassroomsRepository {
  Future<List<ClassroomModel>> getAllClassroomsByTeacherId(String teacherUid);
  Future<ClassroomModel> getClassroomById(String classroomId);
}
