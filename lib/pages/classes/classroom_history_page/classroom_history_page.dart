import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/history_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomHistoryPage extends StatefulWidget {
  final String teacherUid;
  final String? classroomId;

  const ClassroomHistoryPage({
    super.key,
    required this.teacherUid,
    this.classroomId,
  });

  @override
  _ClassroomHistoryPageState createState() => _ClassroomHistoryPageState();
}

class _ClassroomHistoryPageState extends State<ClassroomHistoryPage> {
  // 데이터를 가져왔는지에 대한 여부.
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
      final historyProvider =
          Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.getAllHistorys(widget.classroomId!);
      print('test003');
      _dataFetched = true;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(classroomId: widget.classroomId!),
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
                  "2023년 1월 16일",
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
            //         width: MediaQuery.of(context).size.width * 0.12,
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
            //                     classroomId: classroomData[value]!,
            //                   ); // YourNextScreen은 이동하고자 하는 화면입니다.
            //                 },
            //               ),
            //             );
            //           },
            //           items: myKeyList
            //               .map<DropdownMenuItem<String>>((String value) {
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
      body: Consumer2<ClassroomProvider, StudentProvider>(
        builder: (context, classroomProvider, studentProvider, child) {
          final List<Classroom> classrooms = classroomProvider.classrooms;
          final List<Student> students = studentProvider.students;

          return Row(
            children: [
              // 학생 리스트
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          '기록 보기',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.06,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // Drawer 닫기
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: Row(
                          children: [
                            const Text('모든 학생'),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // Drawer 닫기
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: const Icon(Icons.class_outlined),
                        title: Row(
                          children: [
                            const Text('학생1'),
                            Spacer(),
                            Image.asset(
                                'assets/buttons/arrow_down_button_2.png')
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: Row(
                          children: [
                            const Text('학생2'),
                            Spacer(),
                            Image.asset(
                                'assets/buttons/arrow_down_button_2.png')
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // Drawer 닫기
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_add),
                        title: Row(
                          children: [
                            const Text('학생3'),
                            Spacer(),
                            Image.asset(
                                'assets/buttons/arrow_down_button_2.png')
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // Drawer 닫기
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  // color: Colors.yellow,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 확장
                    children: [
                      Row(
                        children: [
                          Text(
                            '1월 15일',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.calendar_month),
                              title: Text('일상 이름'),
                              subtitle: Text('2023-01-15 15:32:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.person_add),
                              title: Text('태도 이름'),
                              subtitle: Text('2023-01-15 10:31:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.class_outlined),
                              title: Text('수업 이름'),
                              subtitle: Text('2023-01-15 10:12:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '1월 14일',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.person_add),
                              title: Text('태도 이름'),
                              subtitle: Text('2023-01-14 10:31:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.person_add),
                              title: Text('태도 이름'),
                              subtitle: Text('2023-01-14 09:31:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.person_add),
                              title: Text('태도 이름'),
                              subtitle: Text('2023-01-14 08:31:11'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('자세히 보기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('해당 기록 삭제하기'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
