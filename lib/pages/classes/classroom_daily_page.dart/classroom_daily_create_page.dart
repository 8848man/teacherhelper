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

  DateTime date = DateTime.now();
  bool isLoading = false; // 초기에 로딩 상태를 false로 설정

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _registerDaily() async {
    setState(() {
      isLoading = true; // 버튼을 클릭하면 로딩 상태로 변경
    });
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

    try {
      await _dailyProvider.addDaily(daily, widget.classroomId!);

      // 작업이 완료되면 isLoading을 다시 false로 설정하여 버튼을 활성화
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // 작업 중 에러가 발생한 경우에도 isLoading을 false로 설정하여 버튼을 활성화
      setState(() {
        isLoading = false;
      });

      // 에러 처리 및 메시지 출력
      print('Error: $e');
    }
    Navigator.of(context).pop();
    // 날짜 입력값 Null 체크
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.orange),
        elevation: 2, // 그림자의 높이를 조절 (4는 예시로 사용한 값)
        shadowColor: Colors.orange, // 그림자의 색상을 파란색으로 설정
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.27,
              child: const Text(
                "SCHOOL CHECK",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.46,
              child: Center(
                child: Text(
                  "${date.year}년 ${date.month}월 ${date.day}일",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
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
              onPressed: isLoading ? null : _registerDaily, // 버튼 비활성화 상태 설정
              child: isLoading
                  ? const CircularProgressIndicator() // 로딩 중에는 Circular Progress Indicator 표시
                  : const Text('과제 등록'), // 로딩 중이 아니면 버튼 텍스트 표시
            ),
          ],
        ),
      ),
    );
  }
}
