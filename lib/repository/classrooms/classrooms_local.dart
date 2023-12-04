import 'package:teacherhelper/repository/classrooms/classrooms_repository.dart';

import '../../models/classroom_model.dart';

class ClassroomsLocal extends ClassroomsRepository {
  @override
  Future<List<ClassroomModel>> getAllClassroomsByTeacherId(String teacherUid) {
    // TODO: implement getAllClassroomsByTeacherId
    throw UnimplementedError();
  }

  @override
  Future<ClassroomModel> getClassroomById(String classroomId) {
    // TODO: implement getClassroomById
    throw UnimplementedError();
  }
}
