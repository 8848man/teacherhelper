import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

class StudentRegistrationPage extends StatefulWidget {
  final String classroomId;

  const StudentRegistrationPage({super.key, required this.classroomId});

  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final StudentProvider _studentProvider = StudentProvider();
  final AssignmentProvider _assignmentProvider = AssignmentProvider();
  final DailyProvider _dailyProvider = DailyProvider();

  // 성별 버튼을 위한 변수 및 성별 버튼 값
  static final List<String> _genders = <String>['남자', '여자'];
  String? _selectedGender;
  int? _selectedNumber;

  final List<int> _studentNumbers = [];

  void _generateList() {
    for (int i = 0; i <= 40; i++) {
      _studentNumbers.add(i);
    }
  }

  // 년 월 일을 담을 리스트 선언
  // List<String> _years = [];
  // List<String> _months = [];
  // List<String> _days = [];

  // 실제 년 월 일을 담는 함수
  void _initializeDates() {
    final DateTime now = DateTime.now();
    final int currentYear = now.year;

    // _years =
    //     List<String>.generate(10, (index) => (currentYear - index).toString());
    // _months = List<String>.generate(
    //     12, (index) => (index + 1).toString().padLeft(2, '0'));

    // final int selectedYear = int.parse(_selectedYear ?? currentYear.toString());
    // final int selectedMonth = int.parse(_selectedMonth ?? '1');

    // final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    // _days = List<String>.generate(
    //     daysInMonth, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  // 드롭다운 선택된 버튼을 담을 String을 선언
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _generateList();
  }

  // 선택된 반을 담을 String 선언
  String? _selectedClassroom;

  // 현재 로그인한 유저 uid
  final currentUserUid = AuthService().currentUser()?.uid.toString();

  // 학생 등록 함수. 학생을 등록하고, 반을 설정했을 경우 반까지 등록
  void _registerStudent() async {
    final name = _nameController.text;
    final gender = _selectedGender;
    final studentNumber = _selectedNumber.toString();
    // final birthdate = '$_selectedYear-$_selectedMonth-$_selectedDay';

    // 이름, 성별, 생년월일 값 체크
    if (name == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("이름을 입력해주세요.")));
      return;
    } else if (gender == null || gender == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("성별을 입력해주세요.")));
      return;
    } else if (studentNumber == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("학번을 입력해주세요.")));
      return;
    }
    // else if (birthdate.contains('null')) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("생년월일을 정확히 입력해주세요.")));
    //   return;
    // }

    Student student = Student(
        name: name,
        gender: gender,
        teacherUid: currentUserUid,
        studentNumber: studentNumber);

    String? studentId;
    try {
      studentId = await _studentProvider.create(student, widget.classroomId);

      if (studentId != null) {
        // 반에 등록되어있던 과제들 가져오기
        final assignments = await _assignmentProvider
            .getAssignmentsByClassroom(widget.classroomId);

        // 가져온 과제들을 학생의 assignment 컬렉션에 추가
        for (final assignment in assignments) {
          await _assignmentProvider.addAssignmentToStudent(
              widget.classroomId, studentId, assignment);
        }

        // 반에 등록되어있던 생활 과제들 가져오기
        final dailys =
            await _dailyProvider.getDailysByClassroom(widget.classroomId);
        for (final daily in dailys) {
          await _dailyProvider.addDailysToStudent(
              widget.classroomId, studentId, daily);
        }
      }
    } catch (e) {
      // 학생 생성 실패 처리
      print(e);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // _initializeDates();
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: _selectedNumber,
              onChanged: (newValue) {
                setState(() {
                  _selectedNumber = newValue;
                });
              },
              items: _studentNumbers.map((number) {
                return DropdownMenuItem<int>(
                  value: number,
                  child: Text(number.toString()),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: '학번',
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: _genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: '성별',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _registerStudent();
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
