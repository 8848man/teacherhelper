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

  final List<String> _isGoods = ['선행', '악행'];

  String? _selectedIsGood;

  @override
  void initState() {
    super.initState();
  }

  void _registerAttitude() async {
    final name = _nameController.text;

    // 이름 체크
    if (name == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("과제 이름을 입력해주세요.")));
      return;
    } else if (_selectedIsGood == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("선행인지 악행인지를 체크해주세요.")));
      return;
    }

    // 날짜 입력값 Null 체크
    if (_selectedIsGood != null) {
      final attitude = Attitude(
        name: name,
        // 선행인지 악행인지 여부. 이후 등록시 선택할 수 있도록 추가 필요
        isBad: _selectedIsGood == '악행' ? true : false,
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
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

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
                  "$year년 $month월 $day일",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.2,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SizedBox(
            //         width:
            //             MediaQuery.of(context).size.width * 0.12,
            //         child: DropdownButton<String>(
            //           value: dropdownValue,
            //           icon: const Icon(Icons.arrow_downward),
            //           elevation: 16,
            //           style: const TextStyle(
            //             color: Colors.deepPurple,
            //           ),
            //           underline: Container(
            //             height: 2,
            //             color: Colors.deepPurpleAccent,
            //           ),
            //           onChanged: (String? value) {
            //             // 사용자가 항목을 선택했을 때 실행할 코드
            //             dropdownValue = value!;
            //             Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (BuildContext context) {
            //                   // 이동하고 싶은 화면을 반환하는 builder 함수를 작성합니다.
            //                   return ClassroomDailyPageTapBar(
            //                     classroomId:
            //                         classroomData[value]!,
            //                   ); // YourNextScreen은 이동하고자 하는 화면입니다.
            //                 },
            //               ),
            //             );
            //           },
            //           items: myKeyList
            //               .map<DropdownMenuItem<String>>(
            //                   (String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
                labelText: '추가할 태도 이름',
              ),
            ),
            const SizedBox(height: 16.0),

            // 시작일 드롭다운 버튼
            const Text('선행/악행'),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedIsGood,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedIsGood = newValue;
                      });
                    },
                    items: _isGoods.map((isGood) {
                      return DropdownMenuItem<String>(
                        value: isGood,
                        child: Text(isGood),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText:
                          '착한 일(발표 등)의 경우 선행, 악한 일(떠듦 등)의 경우 악행으로 체크해주세요',
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
