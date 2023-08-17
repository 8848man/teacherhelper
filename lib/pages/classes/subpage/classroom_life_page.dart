//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/assignments/assignment_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_detail_page_bottom_sheet.dart';
import 'package:teacherhelper/pages/students/student_assignments_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomLifePage extends StatefulWidget {
  final String classroomId;

  const ClassroomLifePage({required this.classroomId});

  @override
  State<ClassroomLifePage> createState() => _ClassroomLifePageState();
}

class _ClassroomLifePageState extends State<ClassroomLifePage> {
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
