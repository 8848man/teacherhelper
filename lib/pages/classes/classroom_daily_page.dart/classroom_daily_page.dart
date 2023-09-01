import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomDailyPage extends StatefulWidget {
  final String classroomId;
  final int? order;
  final DateTime? now;
  final String? dailyId;

  const ClassroomDailyPage(
      {required this.classroomId, this.order, this.now, this.dailyId});

  @override
  State<ClassroomDailyPage> createState() => _ClassroomDailyPageState();
}

class _ClassroomDailyPageState extends State<ClassroomDailyPage> {
  @override
  void initState() {
    super.initState();
  }

  List<bool> cardStates = []; // 각 카드의 상태를 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    final classroomProvider = Provider.of<ClassroomProvider>(context);
    final classroom = classroomProvider.getClassroomById(widget.classroomId);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            FutureBuilder<List<Student>>(
              future: Provider.of<StudentProvider>(context)
                  .getStudentsByClassroom(widget.classroomId),
              builder: (context, snapshot) {
                final List<Student> students =
                    snapshot.data ?? []; // null이면 빈 리스트 사용

                // 처음에 카드 상태 리스트를 초기화
                if (cardStates.isEmpty) {
                  cardStates = List.generate(students.length, (index) => false);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(100.0),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            students.length >= 20 ? 10 : 5, // 그리드 열의 수
                        crossAxisSpacing:
                            students.length >= 20 ? 3 : 100, // 열 간 간격
                        mainAxisSpacing:
                            students.length >= 20 ? 3 : 100, // 행 간 간격
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final dailyProvider =
                            Provider.of<DailyProvider>(context, listen: false);
                        final student = students[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              print('test001');
                              print(widget.classroomId);
                              print(student.id);
                              print(widget.dailyId);
                              dailyProvider.checkDaily(widget.classroomId,
                                  student.id!, widget.dailyId!);
                              cardStates[index] = !cardStates[index];
                            });
                          },
                          onLongPress: () {
                            _navigateToStudentAssignments(context, student.id);
                          },
                          child: Card(
                            color: cardStates[index]
                                ? Colors.red
                                : Colors.grey, // 상태에 따라 색상 조정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(student.name),
                                // Text("학번: ${student.id}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
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
