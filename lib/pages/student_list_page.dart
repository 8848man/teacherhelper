import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/student_service.dart';

// class StudentListPage extends StatefulWidget {
//   @override
//   _StudentListPageState createState() => _StudentListPageState();
// }

// class _StudentListPageState extends State<StudentListPage> {
//   final studentProvider = StudentProvider();
//   List<Student> students = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchStudents();
//   }

//   Future<void> fetchStudents() async {
//     final studentService = StudentService(studentProvider);
//     await studentService.fetchStudents(); // await 키워드 추가

//     setState(() {
//       students = studentProvider.students; // 수정된 코드
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StudentProvider>(
//       builder: (context, studentProvider, child) {
//         final List<Student> students = studentProvider.students;
//         print('test001');
//         print(students);
//         if (students.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: Text('학생 목록'),
//             actions: [],
//           ),
//           body: ListView.builder(
//             itemCount: students.length,
//             itemBuilder: (BuildContext context, int index) {
//               final student = students[index];
//               return ListTile(
//                 title: Text(student.name ?? 'Unnamed student'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('성별: ${student.gender ?? '-'}'),
//                     Text('생년월일: ${student.birthdate ?? '-'}'),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final StudentProvider studentProvider = StudentProvider();

  List<Student> students = [];
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  // StudentProvider에 있는 students에 데이터를 저장
  Future<void> fetchStudents() async {
    final StudentService studentService = StudentService(studentProvider);
    await studentService.fetchStudents();

    setState(() {
      students = studentProvider.students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) {
        if (students.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('학생 목록'),
            actions: [],
          ),
          body: ListView.builder(
            itemCount: students.length,
            itemBuilder: (BuildContext context, int index) {
              final student = students[index];
              return ListTile(
                title: Text(student.name ?? 'Unnamed student'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('성별: ${student.gender ?? '-'}'),
                    Text('생년월일: ${student.birthdate ?? '-'}'),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
