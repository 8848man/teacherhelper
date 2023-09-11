import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/services/classroom_service.dart';

class ClassroomRegistPage extends StatefulWidget {
  final String teacherUid;

  ClassroomRegistPage({
    required this.teacherUid,
  });

  @override
  _ClassroomRegistPageState createState() => _ClassroomRegistPageState();
}

class _ClassroomRegistPageState extends State<ClassroomRegistPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final studentsProvider = StudentProvider();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
  }

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

class ClassroomRegistPage_reform extends StatefulWidget {
  final String teacherUid;
  final String? classroomId;
  final bool isModify;

  ClassroomRegistPage_reform(
      {required this.teacherUid, this.classroomId, required this.isModify});

  @override
  _ClassroomRegistPage_reformState createState() =>
      _ClassroomRegistPage_reformState();
}

class _ClassroomRegistPage_reformState
    extends State<ClassroomRegistPage_reform> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _gradeController = TextEditingController();

  bool _dataFetched = false;

  @override
  initState() {
    super.initState();

    if (!_dataFetched) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      final studentProvider =
          Provider.of<StudentProvider>(context, listen: false);

      studentProvider.resetStudents();
      if (widget.classroomId != null) {
        await studentProvider.fetchStudentsByClassroom(widget.classroomId!);
      }
      _dataFetched = true;
    } catch (e) {}
  }

  MyTextField() {
    // 글자 수 제한을 10으로 설정
    _classNameController.addListener(() {
      if (_classNameController.text.length > 10) {
        _classNameController.text = _classNameController.text.substring(0, 10);
        _classNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _classNameController.text.length),
        );
      }
    });
  }

  bool _isLoading = false;

  Future<void> _createClassroom(ClassroomProvider classroomProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final classroom = Classroom(
        name: _classNameController.text,
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
    return Scaffold(
      body: Consumer2<ClassroomProvider, StudentProvider>(
        builder: (context, classroomProvider, studentProvider, child) {
          final List<Classroom> classrooms = classroomProvider.classrooms;
          final List<Student> students = studentProvider.students;
          return Column(
            children: [
              Container(
                // color: Colors.yellow,
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * 0.05,
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                // 상단의 텍스트 컨테이너
                child: Container(
                  child: Text(
                    widget.isModify == true ? '학반 수정' : '학반 등록',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 48.0,
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: 1.0,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // 카드 컨테이너를 위한 패딩
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.05,
                    0,
                    MediaQuery.of(context).size.width * 0.05,
                    MediaQuery.of(context).size.height * 0.05),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xFFFFE8E0), // 색상 코드를 Color 클래스로 변환하여 사용
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white, // 색상 코드를 Color 클래스로 변환하여 사용
                              border: Border.all(color: Color(0xFFC4C4C4)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.04, // 원하는 글꼴 크기 설정
                                    ),
                                    decoration: InputDecoration(
                                      border:
                                          InputBorder.none, // Remove the border
                                      hintText: '학반명을 입력해주세요',
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          10), // 최대 글자 수 제한
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Row(
                                    children: [
                                      // delete 버튼, 엑셀 가져오기 버튼, 등록하기 버튼
                                      Image.asset(
                                          'assets/buttons/class_delete_button.jpg'),
                                      Image.asset(
                                          'assets/buttons/class_exel_import_button.jpg'),
                                      Image.asset(
                                          'assets/buttons/class_regist_button.jpg'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05)
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.05,
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.width * 0.05,
                                MediaQuery.of(context).size.height * 0.05),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  // 목록
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(
                                              0xFFEAECF0), // 바닥 border의 색상 설정
                                          width: 2.0, // 바닥 border의 두께 설정
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          child: Image.asset(
                                            'assets/buttons/checkbox_button.jpg',
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Row(
                                            children: [
                                              Text(
                                                '번호',
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text('이름'),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Text('성별'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 등록되어있는 학생들
                                  SingleChildScrollView(
                                    child: Column(children: [
                                      Column(
                                        children: List.generate(
                                          students.length,
                                          (index) {
                                            final student = students[index];
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(
                                                        0xFFEAECF0), // 바닥 border의 색상 설정
                                                    width:
                                                        2.0, // 바닥 border의 두께 설정
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    child: Image.asset(
                                                      'assets/buttons/default_checkbox_button.jpg',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          student
                                                              .studentNumber!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: Text(student.name),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child: Text(student.gender),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(
                                                  0xFFEAECF0), // 바닥 border의 색상 설정
                                              width: 2.0, // 바닥 border의 두께 설정
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              child: Image.asset(
                                                'assets/buttons/default_checkbox_button.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '추가학생번호',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Text('추가학생이름'),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: Text('추가학생성별'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
