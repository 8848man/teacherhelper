import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/assignments/assignment_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_violation_page_bottom_sheet.dart';
import 'package:teacherhelper/pages/daily/daily_create_page.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomDailyPage extends StatefulWidget {
  final String classroomId;

  const ClassroomDailyPage({required this.classroomId});

  @override
  State<ClassroomDailyPage> createState() => _ClassroomDailyPagePageState();
}

class _ClassroomDailyPagePageState extends State<ClassroomDailyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classroomProvider = Provider.of<ClassroomProvider>(context);
    final classroom = classroomProvider.getClassroomById(widget.classroomId);
    bool isBottomSheetOpen = false; // BottomSheet가 열려있는지 여부를 저장하는 변수
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("반 이름: ${classroom.name},"),
            SizedBox(height: 16.0),
            Text("학년: ${classroom.grade}"),
            SizedBox(height: 16.0),
            Text("선생님: ${classroom.teacher}"),
            SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            FutureBuilder<List<Student>>(
              future: Provider.of<StudentProvider>(context)
                  .getStudentsByClassroom(widget.classroomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터 로딩 중
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 데이터 로딩 중에 오류 발생
                  return Text('Error: ${snapshot.error}');
                } else {
                  // 데이터 로딩 완료
                  final List<Student> students = snapshot.data!;
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
                                  isBottomSheetOpen =
                                      false; // BottomSheet가 닫혔으므로 상태를 업데이트
                                });
                              });
                              setState(() {
                                isBottomSheetOpen =
                                    true; // BottomSheet가 열렸으므로 상태를 업데이트
                              });
                            },
                            onLongPress: () {
                              _navigateToStudentAssignments(
                                  context, student.id);
                            },
                            child: Card(
                              color: isBottomSheetOpen
                                  ? Colors.black
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
                }
              },
            ),
            // 학생 추가 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => StudentRegistrationPage(
                    classroomId: widget.classroomId,
                  ),
                ))
                    .then((result) {
                  setState(() {});
                });
              },
              child: Text('학생 등록하기'),
            ),
            // 학생 삭제 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomStudentDeletePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('학생 삭제하기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyCreatePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('반 과제 등록하기'),
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

class ClassroomClassesPage extends StatefulWidget {
  final String classroomId;

  const ClassroomClassesPage({required this.classroomId});

  @override
  State<ClassroomClassesPage> createState() => _ClassroomClassesPageState();
}

class _ClassroomClassesPageState extends State<ClassroomClassesPage> {
  @override
  void initState() {
    super.initState();
  }

  final int itemCountPerScreen = 5;

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
            Text("반 이름: ${classroom.name},"),
            SizedBox(height: 16.0),
            Text("학년: ${classroom.grade}"),
            SizedBox(height: 16.0),
            Text("선생님: ${classroom.teacher}"),
            SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            FutureBuilder<List<Student>>(
              future: Provider.of<StudentProvider>(context)
                  .getStudentsByClassroom(widget.classroomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터 로딩 중
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 데이터 로딩 중에 오류 발생
                  return Text('Error: ${snapshot.error}');
                } else {
                  // 데이터 로딩 완료
                  final List<Student> students = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("학생들:"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return ListTile(
                            title: Text(student.name),
                            subtitle: Text("학번: ${student.id}"),
                            onTap: () {
                              // _showBottomSheet(
                              //     context, widget.classroomId, student.id);
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return StudentAssignmentBottomSheet(
                                    classroomId: widget.classroomId,
                                    studentId: student.id,
                                  );
                                },
                              );
                            },
                            // 학생 누르고있을 경우 학생 과제 페이지에 진입
                            onLongPress: () {
                              _navigateToStudentAssignments(
                                  context, student.id);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            // 학생 추가 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => StudentRegistrationPage(
                    classroomId: widget.classroomId,
                  ),
                ))
                    .then((result) {
                  setState(() {});
                });
              },
              child: Text('학생 등록하기'),
            ),
            // 학생 삭제 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomStudentDeletePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('학생 삭제하기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentCreatePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('반 과제 등록하기'),
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

class ClassroomViolationPage extends StatefulWidget {
  final String classroomId;

  const ClassroomViolationPage({required this.classroomId});

  @override
  State<ClassroomViolationPage> createState() => _ClassroomViolationPageState();
}

class _ClassroomViolationPageState extends State<ClassroomViolationPage> {
  @override
  void initState() {
    super.initState();
  }

  final int itemCountPerScreen = 5;

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
            Text("반 이름: ${classroom.name},"),
            SizedBox(height: 16.0),
            Text("학년: ${classroom.grade}"),
            SizedBox(height: 16.0),
            Text("선생님: ${classroom.teacher}"),
            SizedBox(height: 16.0),
            //반에 등록된 학생 리스트
            FutureBuilder<List<Student>>(
              future: Provider.of<StudentProvider>(context)
                  .getStudentsByClassroom(widget.classroomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터 로딩 중
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 데이터 로딩 중에 오류 발생
                  return Text('Error: ${snapshot.error}');
                } else {
                  // 데이터 로딩 완료
                  final List<Student> students = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("학생들:"),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: students.length,
                      //   itemBuilder: (context, index) {
                      //     final student = students[index];
                      //     return ListTile(
                      //       title: Text(student.name),
                      //       subtitle: Text("학번: ${student.id}"),
                      //       onTap: () {
                      //         // _showBottomSheet(
                      //         //     context, widget.classroomId, student.id);
                      //         showModalBottomSheet(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return StudentAssignmentBottomSheet(
                      //               classroomId: widget.classroomId,
                      //               studentId: student.id,
                      //             );
                      //           },
                      //         );
                      //       },
                      //       // 학생 누르고있을 경우 학생 과제 페이지에 진입
                      //       onLongPress: () {
                      //         _navigateToStudentAssignments(
                      //             context, student.id);
                      //       },
                      //     );
                      //   },
                      // ),
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
                              );
                            },
                            onLongPress: () {
                              _navigateToStudentAssignments(
                                  context, student.id);
                            },
                            child: Card(
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
                }
              },
            ),
            // 학생 추가 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => StudentRegistrationPage(
                    classroomId: widget.classroomId,
                  ),
                ))
                    .then((result) {
                  setState(() {});
                });
              },
              child: Text('학생 등록하기'),
            ),
            // 학생 삭제 페이지 진입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomStudentDeletePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('학생 삭제하기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentCreatePage(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
              child: Text('반 과제 등록하기'),
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
