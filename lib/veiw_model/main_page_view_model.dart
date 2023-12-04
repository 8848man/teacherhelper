import 'package:teacherhelper/repository/classrooms/classrooms_repository.dart';
import 'package:teacherhelper/veiw_model/classroom_view_model.dart';

import '../models/classroom_model.dart';

class MainPageViewModel {
  String title = '학반 등록 및 선택';

  ClassroomsRepository? classroomsRepository;
  MainPageViewModel({this.classroomsRepository});

  getClassrooms() {}

  // FireStore에서 유저의 Uid로 데이터 가져오기
  Future<List<ClassroomViewModel>> fetchClassrooms() async {
    List<ClassroomModel> list =
        await classroomsRepository!.getAllClassroomsByTeacherId('teacherUid');
    return list
        .map((classroom) => ClassroomViewModel(classroomModel: classroom))
        .toList();
  }
}
