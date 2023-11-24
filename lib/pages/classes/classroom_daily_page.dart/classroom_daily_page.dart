import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/providers/daily_history_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomDailyPage extends StatefulWidget {
  final String classroomId;
  final int? order;
  final DateTime? now;
  final String? dailyName;

  const ClassroomDailyPage(
      {super.key,
      required this.classroomId,
      this.order,
      this.now,
      this.dailyName});

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
      // await studentProvider.injectDailyToStudents(
      //     widget.classroomId, widget.order!);
      await studentProvider.injectDailyToStudents2(
          widget.classroomId, widget.order!, DateTime.now());
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            Consumer2<StudentProvider, DailyHistoryProvider>(
              builder: (context, studentProvider, dailyHistoryProvider, child) {
                // 학생 저장 변수
                final List<Student> students =
                    studentProvider.studentsWithDaily2;

                // 출석체크등 완료여부를 알기 위한 토큰.
                final List<DailyHistory> latestDailyHistorys =
                    dailyHistoryProvider.latestDailyHistorys;

                // 0910 student sort기능.
                List<int> studentNumbers = students
                    .map((student) => int.parse(student.studentNumber!))
                    .toList()
                  ..sort(
                    (a, b) => a.compareTo(b),
                  );
                List<DailyHistory> filteredHistorys = latestDailyHistorys
                    .where((history) =>
                        studentNumbers.contains(history.studentNumber))
                    .toList()
                  ..sort(
                      (a, b) => a.studentNumber!.compareTo(b.studentNumber!));

                // 학생 과제 달성 여부 토큰
                List<int?> studentNumberList = [];

                for (int i = 0; i < students.length; i++) {
                  bool isAdded = false;
                  for (int j = 0; j < latestDailyHistorys.length; j++) {
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.dailyName!,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                        ),
                        GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.06,
                            0,
                            MediaQuery.of(context).size.width * 0.06,
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          // padding: EdgeInsets.all(
                          //     MediaQuery.of(context).size.height * 0.08),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: students.length >= 20 ? 8 : 5,
                            crossAxisSpacing: students.length >= 20
                                ? MediaQuery.of(context).size.width * 0.018
                                : 100,
                            mainAxisSpacing: students.length >= 20 ? 3 : 100,
                          ),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return GestureDetector(
                              onTap: () {
                                // Daily가 체크되어있지 않을 경우, Daily를 체크
                                if (student.dailyHistoryData!.isChecked ==
                                    false) {
                                  DailyHistory dailyHistory = DailyHistory(
                                    classroomId: widget.classroomId,
                                    dailyName: widget.dailyName!,
                                    order: widget.order,
                                    studentId: student.id,
                                    dailyId: student.dailyData!.id,
                                    studentName: student.name,
                                    studentNumber:
                                        int.parse(student.studentNumber!),
                                  );
                                  dailyHistoryProvider.checkDaily(
                                    widget.classroomId,
                                    student.studentNumber!,
                                    widget.dailyName!,
                                    student.name,
                                    widget.order,
                                    widget.now,
                                    dailyHistory,
                                  );
                                  if (student.dailyHistoryData != null) {
                                    studentProvider
                                        .setStudentHistoryChecked(student);
                                  }
                                  cardStates[index] = !cardStates[index];
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('체크 해제'),
                                        content: const Text(
                                            '이미 학생 체크가 되어있습니다. 체크를 해제하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              dailyHistoryProvider.unCheckDaily(
                                                widget.classroomId,
                                                student,
                                              );
                                              // 출석 체크 해제 로직 추가
                                              Navigator.of(context)
                                                  .pop(); // 다이얼로그 닫기
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              onLongPress: () {
                                _navigateToStudentAssignments(
                                    context, student.id);
                              },
                              child: Card(
                                color: student.dailyHistoryData == null
                                    ? Colors.grey
                                    : student.dailyHistoryData!.isChecked ==
                                            true
                                        ? const Color(0xFFFE886A)
                                        : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10000.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(student.studentNumber!),
                                    Text(student.name),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
