import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class AssignmentCreatePage extends StatefulWidget {
  final String? classroomId;
  final String? studentId;

  AssignmentCreatePage({this.classroomId, this.studentId});

  @override
  _AssignmentRegistrationPageState createState() =>
      _AssignmentRegistrationPageState();
}

class _AssignmentRegistrationPageState extends State<AssignmentCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final AssignmentProvider _assignmentProvider = AssignmentProvider();
  final StudentProvider _studentProvider = StudentProvider();

  List<String> _years = [];
  List<String> _months = [];
  List<String> _days = [];

  String? _selectedStartYear;
  String? _selectedStartMonth;
  String? _selectedStartDay;

  String? _selectedDeadlineYear;
  String? _selectedDeadlineMonth;
  String? _selectedDeadlineDay;

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() {
    final DateTime now = DateTime.now();
    final int currentYear = now.year;

    _years =
        List<String>.generate(10, (index) => (currentYear - index).toString());
    _months = List<String>.generate(
        12, (index) => (index + 1).toString().padLeft(2, '0'));

    final int selectedStartYear =
        int.parse(_selectedStartYear ?? currentYear.toString());
    final int selectedStartMonth = int.parse(_selectedStartMonth ?? '1');

    final int daysInStartMonth =
        DateTime(selectedStartYear, selectedStartMonth + 1, 0).day;
    _days = List<String>.generate(
        daysInStartMonth, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  void _registerAssignment() async {
    final name = _nameController.text;

    // 이름 체크
    if (name == null || name == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("과제 이름을 입력해주세요.")));
      return;
    }

    // 날짜 입력값 Null 체크
    if (_selectedStartYear != null &&
        _selectedStartMonth != null &&
        _selectedStartDay != null &&
        _selectedDeadlineYear != null &&
        _selectedDeadlineMonth != null &&
        _selectedDeadlineDay != null) {
      final startDate = DateTime(
        int.parse(_selectedStartYear!),
        int.parse(_selectedStartMonth!),
        int.parse(_selectedStartDay!),
      );

      final deadline = DateTime(
        int.parse(_selectedDeadlineYear!),
        int.parse(_selectedDeadlineMonth!),
        int.parse(_selectedDeadlineDay!),
      );

      // 기한일 > 시작일인지 체크
      if (startDate.compareTo(deadline) > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("시작일이 기한일보다 늦습니다. 시작일과 기한일을 확인해주세요.")));
        return;
      }
      final assignment = Assignment(
        name: name,
        isComplete: false,
        startDate: startDate,
        deadline: deadline,
        completeDate: null,
        assignmentFile: null,
      );

      await _assignmentProvider.addAssignment(assignment, widget.classroomId!);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("시작일 또는 기한일을 지정해주세요.")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('과제 등록'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '과제 이름',
              ),
            ),
            SizedBox(height: 16.0),

            // 시작일 드롭다운 버튼
            Text('시작일'),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStartYear,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStartYear = newValue;
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
                    value: _selectedStartMonth,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStartMonth = newValue;
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
                    value: _selectedStartDay,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStartDay = newValue;
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
            SizedBox(height: 16.0),

            // 기한일 드롭다운 버튼
            Text('기한일'),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDeadlineYear,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDeadlineYear = newValue;
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
                    value: _selectedDeadlineMonth,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDeadlineMonth = newValue;
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
                    value: _selectedDeadlineDay,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDeadlineDay = newValue;
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
            SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _registerAssignment,
              child: Text('과제 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
