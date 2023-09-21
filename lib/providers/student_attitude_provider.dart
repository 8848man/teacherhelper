import 'package:flutter/foundation.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class StudentAttitudeProvider extends ChangeNotifier {
  StudentProvider studentProvider = StudentProvider();
  AttitudeProvider attitudeProvider = AttitudeProvider();

  List<Student> _studentsWithAttitude = [];
  List<Student> get studentsWithAttitude => _studentsWithAttitude;

  // 학생과 attitude 데이터를 결합
  Future<void> combineStudentsAndAttitudes() async {
    // ClassroomProvider와 AssignmentProvider의 데이터를 사용하여 가공
    final studentData = studentProvider.students;
    final attitudeData = attitudeProvider.attitudes;
    // studentsData를 사용하여 원하는 가공 작업 수행

    for (Student student in studentData) {
      for (var attitude in attitudeData) {
        if (attitude.studentId == student.id) {
          student.order = attitude.order;
          student.point = attitude.point;
          _studentsWithAttitude.add(student);
        }
      }
    }

    // 가공한 결과를 필요한 상태로 업데이트
    notifyListeners();
  }

  // 결합된 stduentWithAttitude 데이터를 order에 따라 가져오기
  Future<List> getStudentsWithAttitude(int order) async {
    await combineStudentsAndAttitudes();
    return studentsWithAttitude
        .where((student) => student.order == order)
        .toList();
  }
}
