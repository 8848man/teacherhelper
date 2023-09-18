import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/providers/daily_provider.dart';

class DailyCreatePage extends StatefulWidget {
  final String? classroomId;
  final String? studentId;

  const DailyCreatePage({super.key, this.classroomId, this.studentId});

  @override
  _DailyCreatePageState createState() => _DailyCreatePageState();
}

class _DailyCreatePageState extends State<DailyCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final DailyProvider _dailyProvider = DailyProvider();

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

  void _registerDaily() async {
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

      final daily = Daily(
        name: name,
        isComplete: false,
        startDate: startDate,
      );

      // await _assignmentProvider.addAssignment(assignment, widget.classroomId!);

      await _dailyProvider.addDaily(daily, widget.classroomId!);

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
              onPressed: _registerDaily,
              child: const Text('과제 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
