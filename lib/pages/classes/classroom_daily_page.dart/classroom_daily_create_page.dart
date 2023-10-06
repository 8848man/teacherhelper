import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/providers/daily_provider.dart';

class DailyCreatePage extends StatefulWidget {
  final String? classroomId;
  final String? studentId;

  const DailyCreatePage({Key? key, this.classroomId, this.studentId})
      : super(key: key);

  @override
  _DailyCreatePageState createState() => _DailyCreatePageState();
}

class _DailyCreatePageState extends State<DailyCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final DailyProvider _dailyProvider = DailyProvider();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _registerDaily() async {
    final name = _nameController.text;

    // 이름 체크
    if (name.isEmpty) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("과제 이름을 입력해주세요.")),
      );
      return;
    }

    final daily = Daily(
      name: name,
      isComplete: false,
      classroomId: widget.classroomId,
    );

    await _dailyProvider.addDaily(daily, widget.classroomId!);

    Navigator.of(context).pop();
    // 날짜 입력값 Null 체크
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
