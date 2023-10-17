import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/date_for_history.dart';
import 'package:teacherhelper/datamodels/history_date.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/history_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomHistoryPageByDaily extends StatefulWidget {
  final String teacherUid;
  final String? classroomId;

  const ClassroomHistoryPageByDaily({
    super.key,
    required this.teacherUid,
    this.classroomId,
  });

  @override
  _ClassroomHistoryPageByDailyState createState() =>
      _ClassroomHistoryPageByDailyState();
}

class _ClassroomHistoryPageByDailyState
    extends State<ClassroomHistoryPageByDaily> {
  // 데이터를 가져왔는지에 대한 여부.
  bool _dataFetched = false;
  bool _isSearched = false;

  String year = DateTime.now().year.toString();
  String month = DateTime.now().month.toString();
  String day = DateTime.now().day.toString();

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
      body: Consumer3<ClassroomProvider, StudentProvider, HistoryProvider>(
        builder: (context, classroomProvider, studentProvider, historyProvider,
            child) {
          final students = studentProvider.students;
          final allHistory = _isSearched == false
              ? historyProvider.allHistory
              : historyProvider.searchedHistory;
          final classroomName = classroomProvider.classroom.name;
          BuildContext? dialogContext; // 임시 context를 위한 변수를 정의

          void _selectEndDate(DateTime startDate) async {
            DateTime? endDate = await showDatePicker(
              context: dialogContext!, // 변수 사용
              initialDate: startDate,
              firstDate: startDate,
              lastDate: DateTime(2101),
            );

            if (endDate != null) {
              int startYear = startDate.year;
              int startMonth = startDate.month;
              int startDay = startDate.day;

              int endYear = endDate.year;
              int endMonth = endDate.month;
              int endDay = endDate.day;

              final dateForHistory = DateForHistory(
                startYear: startYear,
                startMonth: startMonth,
                startDate: startDay,
                endYear: endYear,
                endMonth: endMonth,
                endDate: endDay,
              );

              historyProvider.generateExcel(
                  classroomName, students, dateForHistory);
            }
          }

          void _selectStartDate() async {
            DateTime? startDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (startDate != null) {
              dialogContext = context; // 변수에 저장
              showDialog(
                context: dialogContext!, // 변수 사용
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("마지막일을 설정해주세요"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("확인"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _selectEndDate(startDate);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }

          return Row(
            children: [
              // 학생 리스트
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ListView.builder(
                  itemCount: studentProvider.students.length +
                      3, // 추가된 ListTile 두 개를 포함하여 카운트 설정
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 첫 번째 ListTile
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              '기록 보기',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("시작일을 설정해주세요"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("확인"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // 시작일을 선택하는 DatePicker를 여기서 호출
                                              _selectStartDate();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('엑셀로 출력하기'),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (index == 1) {
                      // 두 번째 ListTile
                      return const Divider();
                    } else if (index == 2) {
                      // 세 번째 ListTile
                      return ListTile(
                        leading: const Icon(Icons.school_sharp),
                        title: const Row(
                          children: [
                            Text('모든 학생'),
                          ],
                        ),
                        onTap: () {
                          _isSearched = false;
                          setState(() {
                            _isSearched = false;
                          });
                        },
                      );
                    } else {
                      // 학생 목록 부분
                      final student = students[index - 3];
                      return GestureDetector(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Row(
                            children: [
                              Text(student.name), // 학생 이름 출력
                              const Spacer(),
                              GestureDetector(
                                child: Image.asset(
                                    'assets/buttons/arrow_down_button_2.png'),
                                onTap: () {},
                              ),
                            ],
                          ),
                          onTap: () {
                            historyProvider.getHistorysByCondition(
                                int.parse(student.studentNumber!));
                            _isSearched = true;
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ListView.builder(
                  itemCount: allHistory.length,
                  itemBuilder: (context, index) {
                    final historyItem = allHistory[index];

                    if (historyItem is HistoryDate) {
                      // historyItem이 문자열인 경우, 날짜를 출력
                      year = historyItem.checkDate.year.toString();
                      month = historyItem.checkDate.month.toString();
                      day = historyItem.checkDate.day.toString();
                      return Row(
                        children: [
                          Text(
                            '$year년 $month월 $day일',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                          const Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ],
                      );
                    } else if (historyItem is Attitude) {
                      final studentName = historyItem.studentName;
                      // Attitude 데이터 처리
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.person_add),
                              title: Row(
                                children: [
                                  Text(historyItem.name),
                                  Text(' (${studentName!})'),
                                ],
                              ),
                              subtitle: Text(historyItem.checkDate.toString()),
                              // 나머지 ListTile 구성 및 작업 추가
                            ),
                          ],
                        ),
                      );
                    } else if (historyItem is DailyHistory) {
                      final studentName = historyItem.studentName;
                      // DailyHistory 데이터 처리
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: Row(
                                children: [
                                  Text(historyItem.dailyName!),
                                  Text(' (${studentName!})'),
                                ],
                              ),
                              subtitle: Text(historyItem.checkDate.toString()),
                              // trailing: Text('test'),
                              // 나머지 ListTile 구성 및 작업 추가
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox(); // 다른 경우에 대한 처리
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
