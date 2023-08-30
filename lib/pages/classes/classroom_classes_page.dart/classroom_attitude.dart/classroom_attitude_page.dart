import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_sub_page.dart';
import 'package:teacherhelper/pages/classes/classroom_classes_page.dart/classroom_attitude.dart/classroom_attitude_page_bottom_sheet.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomAttitudePage extends StatefulWidget {
  final String classroomId; // classroomId 변수 추가

  ClassroomAttitudePage({required this.classroomId});

  @override
  _ClassroomAttitudePageState createState() => _ClassroomAttitudePageState();
}

class _ClassroomAttitudePageState extends State<ClassroomAttitudePage> {
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
      drawer: NavBar(),
      appBar: AppBar(title: Text("반 태도 페이지")),
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
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10, // 그리드 열의 수
                        crossAxisSpacing: 3, // 열 간 간격
                        mainAxisSpacing: 3, // 행 간 간격
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StudentAssignmentBottomSheet(
                                  classroomId: widget.classroomId,
                                  studentId: student.id,
                                );
                              },
                            ).whenComplete(() {
                              // BottomSheet가 닫힐 때 호출되는 함수
                              setState(() {
                                cardStates[index] =
                                    false; // BottomSheet가 닫혔으므로 상태를 업데이트
                              });
                            });
                            setState(() {
                              cardStates[index] =
                                  true; // BottomSheet가 열렸으므로 상태를 업데이트
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
                              borderRadius: BorderRadius.circular(100.0),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Handle first button's action
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentRegistrationPage(
                    classroomId: widget.classroomId,
                  ),
                ),
              );
            },
            child: Icon(Icons.person_add_alt),
            tooltip: '학생 등록하기', // Tooltip에 표시할 텍스트
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // Handle second button's action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassroomStudentDeletePage(
                    classroomId: widget.classroomId,
                  ),
                ),
              );
            },
            child: Icon(Icons.person_remove_alt_1_outlined),
            tooltip: '학생 삭제하기',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // Handle second button's action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyCreatePage(
                    classroomId: widget.classroomId,
                  ),
                ),
              );
            },
            child: Icon(Icons.add_circle_outline),
            tooltip: '일과 과제 등록하기',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // Handle second button's action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassroomStudentDeletePage(
                    classroomId: widget.classroomId,
                  ),
                ),
              );
            },
            child: Icon(Icons.remove_circle_outline),
            tooltip: '일과 과제 삭제하기',
          ),
        ],
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
