import 'package:teacherhelper/models/classroom_model.dart';

class ClassroomViewModel {
  ClassroomModel? classroomModel;
  ClassroomViewModel({this.classroomModel});

  get id => classroomModel?.id;
  get teacherUid => classroomModel?.teacherUid;
  get name => classroomModel?.name;
  get createdDate => classroomModel?.createdDate;
  get isDeleted => classroomModel?.isDeleted;
  get deletedTime => classroomModel?.deletedDate;
}
