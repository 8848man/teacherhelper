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
  final _studentNameController = TextEditingController();
  final _studentNumberController = TextEditingController();

  // 데이터를 가져왔는지에 대한 여부.
  bool _dataFetched = false;
  bool _gotIsChecked = false;
  List<bool> isChecked = [];

  // 학생 추가 line에 필요한 변수
  bool nameHintVisible = true;
  bool numberHintVisible = true;
  String gender = '남자';

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

  Future<void> _createClassroom() async {
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
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

  Future<void> _modifyClassroom() async {
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
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

      await classroomProvider.modifyClassroom(classroom);

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
      body: SingleChildScrollView(
        child: Consumer2<ClassroomProvider, StudentProvider>(
          builder: (context, classroomProvider, studentProvider, child) {
            final List<Classroom> classrooms = classroomProvider.classrooms;
            final List<Student> students = studentProvider.students;
            print('test001');
            print(students.length);
            if (_gotIsChecked == false) {
              isChecked =
                  List<bool>.generate(students.length, (index) => false);
            }

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
                        fontSize: MediaQuery.of(context).size.height * 0.055,
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
                                color:
                                    Colors.white, // 색상 코드를 Color 클래스로 변환하여 사용
                                border: Border.all(color: Color(0xFFC4C4C4)),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.04, // 원하는 글꼴 크기 설정
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder
                                            .none, // Remove the border
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
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/buttons/class_delete_button.jpg'),
                                          onTap: () {},
                                        ),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/buttons/class_exel_import_button.jpg'),
                                          onTap: () {},
                                        ),
                                        GestureDetector(
                                            child: Image.asset(
                                                'assets/buttons/class_regist_button.jpg'),
                                            onTap: () {}),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    // 목록 컨테이너
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

                                              print('test004');
                                              // 학생들의 isChecked를 저장하는 기능. _gotIsChecked는 화면이 다시 그려질 때 초기화하지 않기 위함.
                                              if (!_gotIsChecked) {
                                                print('test002');
                                                isChecked = students
                                                    .map((student) =>
                                                        student.isChecked ??
                                                        false)
                                                    .toList();
                                                _gotIsChecked = true;
                                                print('test003');
                                              }

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
                                                      child: GestureDetector(
                                                        child: isChecked[
                                                                    index] ==
                                                                true
                                                            ? Image.asset(
                                                                'assets/buttons/class_checked_button.png')
                                                            : Image.asset(
                                                                'assets/buttons/default_checkbox_button.jpg'),
                                                        onTap: () {
                                                          setState(() {
                                                            // 학생 체크 토글
                                                            isChecked[index] =
                                                                !isChecked[
                                                                    index];
                                                          });
                                                        },
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
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: student.gender ==
                                                                '남자'
                                                            ? Image.asset(
                                                                'assets/buttons/gender_badge_base_male.png')
                                                            : Image.asset(
                                                                'assets/buttons/gender_badge_base_female.png'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                                child: GestureDetector(
                                                  child: Image.asset(
                                                    'assets/buttons/default_checkbox_button.jpg',
                                                  ),
                                                  onTap: () {
                                                    studentProvider.addStudent(
                                                        int.parse(
                                                            _studentNumberController
                                                                .text),
                                                        _studentNameController
                                                            .text,
                                                        gender);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: TextField(
                                                    controller:
                                                        _studentNumberController,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            numberHintVisible
                                                                ? '추가 학생 번호'
                                                                : '',
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .blue[300])),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          3), // 여기서 5는 입력 가능한 최대 길이
                                                    ],
                                                    // 다른 속성 및 기타 설정
                                                  )),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: TextField(
                                                  controller:
                                                      _studentNameController,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: nameHintVisible
                                                          ? '추가학생이름'
                                                          : '',
                                                      hintStyle: TextStyle(
                                                          color: Colors
                                                              .blue[300])),
                                                  onChanged: (text) {
                                                    setState(() {
                                                      nameHintVisible =
                                                          text.isEmpty;
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: gender == '남자'
                                                        ? Image.asset(
                                                            'assets/buttons/gender_badge_base_male.png')
                                                        : Image.asset(
                                                            'assets/buttons/gender_badge_base_female.png'),
                                                    onTap: () {
                                                      setState(() {
                                                        if (gender == '남자') {
                                                          gender = '여자';
                                                        } else {
                                                          gender = '남자';
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
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
      ),
    );
  }
}
