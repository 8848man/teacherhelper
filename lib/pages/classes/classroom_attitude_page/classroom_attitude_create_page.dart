import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';

class AttitudeCreatePage extends StatefulWidget {
  final String? classroomId;
  final String? studentId;

  const AttitudeCreatePage({super.key, this.classroomId, this.studentId});

  @override
  _AttitudeCreatePageState createState() => _AttitudeCreatePageState();
}

class _AttitudeCreatePageState extends State<AttitudeCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final AttitudeProvider _attitudeProvider = AttitudeProvider();

  List<String> _years = [];
  List<String> _months = [];
  List<String> _days = [];

  String? _selectedStartYear;
  String? _selectedStartMonth;
  String? _selectedStartDay;

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

  void _registerAttitude() async {
    final name = _nameController.text;

    // 이름 체크
    if (name == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("과제 이름을 입력해주세요.")));
      return;
    }

    // 날짜 입력값 Null 체크
    if (_selectedStartYear != null &&
        _selectedStartMonth != null &&
        _selectedStartDay != null) {
      final startDate = DateTime(
        int.parse(_selectedStartYear!),
        int.parse(_selectedStartMonth!),
        int.parse(_selectedStartDay!),
      );

      final attitude = Attitude(
        name: name,
        startDate: startDate,
        // 선행인지 악행인지 여부. 이후 등록시 선택할 수 있도록 추가 필요
        isBad: true,
      );

      // await _assignmentProvider.addAssignment(assignment, widget.classroomId!);

      await _attitudeProvider.addAttitude(attitude, widget.classroomId!);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("시작일 또는 기한일을 지정해주세요.")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일상 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '일상 과제 이름',
              ),
            ),
            const SizedBox(height: 16.0),

            // 시작일 드롭다운 버튼
            const Text('시작일'),

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
                    decoration: const InputDecoration(
                      labelText: '년',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
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
                    decoration: const InputDecoration(
                      labelText: '월',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
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
                    decoration: const InputDecoration(
                      labelText: '일',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _registerAttitude,
              child: const Text('과제 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
