import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_history_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomDailyPage extends StatefulWidget {
  final String classroomId;
  final int? order;
  final DateTime? now;
  final String? dailyName;

  const ClassroomDailyPage(
      {required this.classroomId, this.order, this.now, this.dailyName});

  @override
  State<ClassroomDailyPage> createState() => _ClassroomDailyPageState();
}

class _ClassroomDailyPageState extends State<ClassroomDailyPage> {
  bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    if (!_dataFetched) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      final studentProvider =
          Provider.of<StudentProvider>(context, listen: false);
      final dailyHistoryProvider =
          Provider.of<DailyHistoryProvider>(context, listen: false);

      await studentProvider.fetchStudentsByClassroom(widget.classroomId);
      await dailyHistoryProvider.fetchDailysByClassroomIdAndDailyOrder(
          widget.classroomId, widget.order);
      // await dailyProvider.fetchDailysByClassroomId(
      //     widget.classroomId, widget.order);
      // 데이터가 로드되면 cardStates를 초기화하고 상태를 갱신
      setState(() {
        cardStates =
            List.generate(studentProvider.students.length, (index) => false);
        _dataFetched = true; // 데이터 가져옴 표시
      });
    } catch (e) {
      // 에러 처리
      print('Error fetching data: $e');
    }
  }

  List<bool> cardStates = []; // 각 카드의 상태를 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            Consumer2<StudentProvider, DailyHistoryProvider>(
              builder: (context, studentProvider, dailyHistoryProvider, child) {
                // 학생 저장 변수
                final List<Student> students = studentProvider.students;

                // 출석체크등 완료여부를 알기 위한 토큰.
                final List<DailyHistory> latestDailyHistorys =
                    dailyHistoryProvider.latestDailyHistorys;

                // List<DailyHistory> latestDailyHistory;

                int maxStudentNumber = students.length; // students 리스트의 최대 길이

                List<DailyHistory?> latestDailyHistory =
                    List<DailyHistory?>.filled(maxStudentNumber, null);

                // for (int i = 0; i < maxStudentNumber; i++) {
                //   final studentNumber =
                //       latestDailyHistorys[i].studentNumber!.toInt();

                //   if (studentNumber >= 1 && studentNumber <= maxStudentNumber) {
                //     latestDailyHistory[studentNumber - 1] =
                //         latestDailyHistorys[i];
                //   }
                // }
                // print('test001');
                // print(latestDailyHistory[4]);
                // print(latestDailyHistorys);
                if (students.isEmpty) {
                  return CircularProgressIndicator(); // 데이터 로딩 중
                } else {
                  // 데이터가 로드되었을 때
                  if (cardStates.isEmpty) {
                    cardStates =
                        List.generate(students.length, (index) => false);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.all(100.0),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: students.length >= 20 ? 10 : 5,
                          crossAxisSpacing: students.length >= 20 ? 3 : 100,
                          mainAxisSpacing: students.length >= 20 ? 3 : 100,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          // final dailyHistory = dailyHistorys[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                dailyHistoryProvider.checkDaily(
                                  widget.classroomId,
                                  student.studentNumber!,
                                  widget.dailyName!,
                                  student.name,
                                  widget.order,
                                  widget.now,
                                );
                                cardStates[index] = !cardStates[index];
                              });
                            },
                            onLongPress: () {
                              _navigateToStudentAssignments(
                                  context, student.id);
                            },
                            child: Card(
                              color:
                                  cardStates[index] ? Colors.red : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10000.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(student.name),
                                  Text(student.studentNumber!),
                                  // Text(dailyHistory.name),
                                  // Text("학번: ${student.id}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _navigateToStudentAssignments(BuildContext context, String? studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentAssignmentPage(
          studentId: studentId,
          classroomId: widget.classroomId,
        ),
      ),
    );
  }
}
