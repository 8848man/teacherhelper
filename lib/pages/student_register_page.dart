import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRegistrationPage extends StatefulWidget {
  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference _classesCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 성별 버튼을 위한 변수 및 성별 버튼 값
  static List<String> _genders = <String>['남자', '여자'];
  String? _selectedGender;

  // 년 월 일을 담을 리스트 선언
  List<String> _years = [];
  List<String> _months = [];
  List<String> _days = [];

  // 실제 년 월 일을 담는 함수
  void _initializeDates() {
    final DateTime now = DateTime.now();
    final int currentYear = now.year;

    _years =
        List<String>.generate(10, (index) => (currentYear - index).toString());
    _months = List<String>.generate(
        12, (index) => (index + 1).toString().padLeft(2, '0'));

    final int selectedYear = int.parse(_selectedYear ?? currentYear.toString());
    final int selectedMonth = int.parse(_selectedMonth ?? '1');

    final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    _days = List<String>.generate(
        daysInMonth, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  // 드롭다운 선택된 버튼을 담을 String을 선언
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _fetchClassrooms();
  }

  // 반 등록을 위한 반 목록
  List<String> _classrooms = [];
  // 선택된 반을 담을 String 선언
  String? _selectedClassroom;
  // _classrooms에 classrooms 컬랙션 데이터 가져오기
  Future<void> _fetchClassrooms() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('classrooms').get();
      setState(() {
        _classrooms =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      // Error handling
    }
  }

  // 학생 등록 함수. 학생을 등록하고, 반을 설정했을 경우 반까지 등록
  void _registerStudent() {
    final name = _nameController.text;
    final gender = _selectedGender;
    final birthdate = '$_selectedYear-$_selectedMonth-$_selectedDay';

    // 이름, 성별, 생년월일 값 체크
    if (name == null || name == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("이름을 입력해주세요.")));
      return;
    } else if (birthdate.contains('null')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("생년월일을 정확히 입력해주세요.")));
      return;
    } else if (gender == null || gender == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("성별을 입력해주세요.")));
      return;
    }

    // 학생 등록
    _studentsCollection.add({
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
    }).then((docRef) {
      // 반 등록
      if (_selectedClassroom != null) {
        FirebaseFirestore.instance
            .collection('classrooms')
            .doc(_selectedClassroom)
            .update({
          'students': FieldValue.arrayUnion([docRef.id])
        });
      }

      // 등록 후 홈 화면 등으로 이동
      Navigator.of(context).pop();
    }).catchError((error) {
      // 등록 중 에러 처리
      final errorMessage = '학생 등록 중 오류가 발생했습니다.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      print('등록 에러: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    _initializeDates();
    return Scaffold(
      appBar: AppBar(
        title: Text('학생 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
              ),
            ),
            SizedBox(height: 16.0),

            // 생년월일 입력 드롭다운버튼 묶음
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                    },
                    items: _years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: '년',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                    },
                    items: _months.map((month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: '월',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDay,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDay = newValue;
                      });
                    },
                    items: _days.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: '일',
                    ),
                  ),
                ),
              ],
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
              decoration: InputDecoration(
                labelText: '성별',
              ),
            ),
            SizedBox(height: 16.0),

            // 반 선택 필드
            DropdownButtonFormField<String>(
              value: _selectedClassroom,
              onChanged: (newValue) {
                setState(() {
                  _selectedClassroom = newValue;
                });
              },
              items: _classrooms.map((classroom) {
                return DropdownMenuItem<String>(
                  value: classroom,
                  child: Text(classroom),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: '반 선택',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _registerStudent,
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
