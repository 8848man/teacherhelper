// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../datamodels/classroom.dart';

// class CreateClassroomPage extends StatefulWidget {
//   final String teacherUid;

//   CreateClassroomPage({required this.teacherUid});

//   @override
//   _CreateClassroomPageState createState() => _CreateClassroomPageState();
// }

// class _CreateClassroomPageState extends State<CreateClassroomPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _gradeController = TextEditingController(); // 학년 추가

//   bool _isLoading = false;

//   // Firestore에 반 등록
//   Future<void> _createClassroom() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Firestore에 새로운 document 생성
//       final documentRef =
//           FirebaseFirestore.instance.collection('classrooms').doc();

//       // Classroom 모델 클래스를 이용하여 document 데이터 설정
//       final classroom = Classroom(
//         id: documentRef.id,
//         name: _nameController.text,
//         teacherUid: widget.teacherUid,
//         grade: int.parse(_gradeController.text), // 학년 추가
//       );

//       await documentRef.set(classroom.toJson());

//       setState(() {
//         _isLoading = false;
//       });

//       // 등록 완료 후 이전 페이지로 이동
//       Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("반 등록에 실패했습니다.")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("반 등록하기")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: "반 이름"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '반 이름을 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _gradeController,
//                 decoration: InputDecoration(labelText: "학년"), // 학년 입력 필드 추가
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '학년을 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _createClassroom,
//                   child:
//                       _isLoading ? CircularProgressIndicator() : Text("반 등록하기"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/services/classroom_service.dart';

class CreateClassroomPage extends StatefulWidget {
  final String teacherUid;

  CreateClassroomPage({required this.teacherUid});

  @override
  _CreateClassroomPageState createState() => _CreateClassroomPageState();
}

class _CreateClassroomPageState extends State<CreateClassroomPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createClassroom(ClassroomProvider classroomProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final classroom = Classroom(
        name: _nameController.text,
        teacherUid: widget.teacherUid,
        grade: int.parse(_gradeController.text),
        id: '',
      );

      await classroomProvider.createClassroom(classroom);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("반 등록에 실패했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final classroomProvider = Provider.of<ClassroomProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("반 등록하기")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "반 이름"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '반 이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _gradeController,
                decoration: InputDecoration(labelText: "학년"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '학년을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _createClassroom(classroomProvider),
                  child:
                      _isLoading ? CircularProgressIndicator() : Text("반 등록하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
