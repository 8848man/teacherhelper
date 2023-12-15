import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/new_daily_provider.dart';
import 'package:teacherhelper/providers/new_student_provider.dart';

import '../../datamodels/new_daily.dart';

//생활 또는 수업 삭제할때 보여주는 dialog
Future<bool> deleteDailyDialog(BuildContext context) async {
  bool returnValue = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('생활/수업 삭제'),
        content: const Text('생활 또는 수업을 삭제하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              returnValue = true;
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  return returnValue;
}

// 학생이 없을 때 보여주는 dialog
void showCustomDialog(BuildContext context) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('학생이 등록되지 않은 반입니다'),
        content: const Text('학생이 등록되지 않은 반입니다'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog 닫기
              // 이전 페이지로 이동
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// 일상 추가 다이얼로그
void showCreateDailyDialog(context, String dailyName, String classroomId) {
  TextEditingController textEditingController = TextEditingController();
  final classroomProvider =
      Provider.of<ClassroomProvider>(context, listen: false);
  final dailyProvider = Provider.of<NewDailyProvider>(context, listen: false);
  final studentProvider =
      Provider.of<NewStudentProvider>(context, listen: false);

  final nowClassroom = classroomProvider.classroom;
  final nowStudents = studentProvider.students;

  // final Map<String, dynamic> data = [];
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('만들고싶은 $dailyName의 이름을 적어주세요'),
        content: Align(
          alignment: Alignment.center,
          child: TextField(
            textAlign: TextAlign.center,
            controller: textEditingController,
            style: const TextStyle(fontSize: 30),
            decoration: InputDecoration(
              hintText: '$dailyName 이름',
              border: InputBorder.none, // 밑줄 제거
              focusedBorder: InputBorder.none, // 포커스된 상태에서 밑줄 제거
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              DateTime nowDate = DateTime.now();
              NewDaily daily = NewDaily(
                classroomId: classroomId,
                studentId: '',
                name: textEditingController.text,
                kind: dailyName,
                isChecked: false,
                createdDate: nowDate,
              );
              await dailyProvider.createDaily(classroomId, nowStudents, daily);
              Navigator.of(context).pop(); // Dialog 닫기
            },
            child: const Text('만들기'),
          ),
        ],
      );
    },
  );
}
