import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/attitudeHistory.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/providers/attitude_history_provider.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomAttitudePage extends StatefulWidget {
  final String classroomId;
  final int? order;
  final DateTime? now;
  final String attitudeName;
  final bool isBad;

  const ClassroomAttitudePage(
      {super.key,
      required this.classroomId,
      this.order,
      this.now,
      required this.attitudeName,
      required this.isBad});

  @override
  State<ClassroomAttitudePage> createState() => _ClassroomAttitudePageState();
}

class _ClassroomAttitudePageState extends State<ClassroomAttitudePage> {
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
      final attitudeHistoryProvider =
          Provider.of<AttitudeHistoryProvider>(context, listen: false);

      await studentProvider.fetchStudentsByClassroom(widget.classroomId);
      await attitudeHistoryProvider.fetchAttitudesByClassroomIdAndAttitudeOrder(
          widget.classroomId, widget.order);

      await studentProvider.injectAttitudeToStudents(
          widget.classroomId, widget.order!);
      // await attitudeProvider.fetchAttitudesByClassroomId(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            Consumer2<StudentProvider, AttitudeHistoryProvider>(
              builder:
                  (context, studentProvider, attitudeHistoryProvider, child) {
                // 학생 저장 변수
                final List<Student> students =
                    studentProvider.studentsWithAttitude;

                // 출석체크등 완료여부를 알기 위한 토큰.
                final List<AttitudeHistory> latestAttitudeHistorys =
                    attitudeHistoryProvider.latestAttitudeHistorys;

                final attitudeProvider =
                    Provider.of<AttitudeProvider>(context, listen: false);

                // 0910 student sort기능.
                List<int> studentNumbers = students
                    .map((student) => int.parse(student.studentNumber!))
                    .toList()
                  ..sort(
                    (a, b) => a.compareTo(b),
                  );
                List<AttitudeHistory> filteredHistorys = latestAttitudeHistorys
                    .where((history) =>
                        studentNumbers.contains(history.studentNumber))
                    .toList()
                  ..sort(
                      (a, b) => a.studentNumber!.compareTo(b.studentNumber!));

                // 학생 과제 달성 여부 토큰
                List<int?> studentNumberList = [];

                for (int i = 0; i < students.length; i++) {
                  bool isAdded = false;
                  for (int j = 0; j < latestAttitudeHistorys.length; j++) {
                    if (studentNumbers[i] ==
                        filteredHistorys[j].studentNumber) {
                      studentNumberList.add(studentNumbers[i]);
                      isAdded = true;
                    }
                  }
                  if (isAdded == false) {
                    studentNumberList.add(null);
                  }
                }

                if (students.isEmpty) {
                  return const CircularProgressIndicator(); // 데이터 로딩 중
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
                        padding: const EdgeInsets.all(100.0),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: students.length >= 20 ? 10 : 5,
                          crossAxisSpacing: students.length >= 20 ? 3 : 100,
                          mainAxisSpacing: students.length >= 20 ? 3 : 100,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          // final attitudeHistory = attitudeHistorys[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Attitude Check'),
                                    content:
                                        const Text('학생의 Attitude를 체크하시겠습니까?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // attitudeHistory에 체크된 기록 추가
                                          attitudeHistoryProvider.checkAttitude(
                                            widget.classroomId,
                                            AttitudeHistory(
                                              studentName: student.name,
                                              studentNumber: int.parse(
                                                  student.studentNumber!),
                                              isAdd: true,
                                              isBad: widget.isBad,
                                              checkDate: widget.now,
                                              order: widget.order,
                                              attitudeName: widget.attitudeName,
                                            ),
                                          );
                                          // attitude에 포인트 추가
                                          attitudeProvider.checkAttitude(
                                              student.attitudeData!,
                                              student.name,
                                              int.parse(
                                                  student.studentNumber!));
                                          cardStates[index] =
                                              !cardStates[index];
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onLongPress: () {
                              _navigateToStudentAssignments(
                                  context, student.id);
                            },
                            child: Card(
                              color: student.attitudeData!.isBad == true
                                  ? getColorByBad(student.attitudeData!.point!)
                                  : getColorByGood(
                                      student.attitudeData!.point!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10000.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(student.studentNumber!),
                                  Text(student.name),
                                  Text(student.attitudeData!.point.toString()),
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

  Color getColorByBad(int currentValue) {
    if (currentValue <= 10) {
      // 0 ~ 10: 노란색에서 오렌지색으로 변화
      final double ratio = currentValue / 10.0;
      return Color.lerp(Colors.yellow, Colors.orange, ratio)!;
    } else {
      // 11 ~ 20: 오렌지색에서 빨간색으로 변화
      final double ratio = (currentValue - 10) / 10.0;
      return Color.lerp(Colors.orange, Colors.red, ratio)!;
    }
  }

  Color getColorByGood(int currentValue) {
    if (currentValue <= 10) {
      // 0 ~ 10: 노란색에서 오렌지색으로 변화
      final double ratio = currentValue / 10.0;
      return Color.lerp(Colors.lightGreen, Colors.green, ratio)!;
    } else {
      // 11 ~ 20: 오렌지색에서 빨간색으로 변화
      final double ratio = (currentValue - 10) / 10.0;
      return Color.lerp(Colors.green, Colors.blue, ratio)!;
    }
  }
}
