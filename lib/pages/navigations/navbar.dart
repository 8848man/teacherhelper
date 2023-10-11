import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/classroom_attitude_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/classroom_attitude_page_tapbar.dart';
import 'package:teacherhelper/pages/classes/classroom_classes_page.dart/classroom_classes_page_tapbar.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_page_tapbar.dart';
import 'package:teacherhelper/pages/classes/classroom_history_page/classroom_history_page_detail.dart';
import 'package:teacherhelper/pages/main_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

class NavBar extends StatefulWidget {
  final String classroomId;
  NavBar({super.key, required this.classroomId});
  List<bool> _isExpanded = [false, false, false];

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer2<ClassroomProvider, AuthService>(
          builder: (context, classroomProvider, authProvider, child) {
        print(MediaQuery.of(context).size.width);
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            // UserAccountsDrawerHeader(
            //   accountName: const Text('선생님 이름 : '),
            //   accountEmail: const Text('반 이름 : '),
            //   currentAccountPicture: CircleAvatar(
            //     child: ClipOval(
            //       child: Image.asset('images/profile.jpg'),
            //     ),
            //   ),
            //   decoration: const BoxDecoration(
            //       color: Colors.pink,
            //       image: DecorationImage(
            //           image: AssetImage('images/back.jpg'), fit: BoxFit.cover)),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈으로'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const MainPage_reform()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_outlined),
              title: const Text('기록'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClassroomHistoryPage(
                      teacherUid: authProvider.currentUser()!.uid,
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    child: Image.asset(
                      'assets/buttons/to-Down.png',
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    onTap: () {
                      setState(
                        () {
                          widget._isExpanded[0] =
                              !widget._isExpanded[0]; // 버튼 그룹 확장/축소 토글
                        },
                      );
                    },
                  ),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          const Text('생활'),
                          Spacer(),
                          GestureDetector(
                            child: Image.asset(
                              'assets/buttons/class_plus_button.jpg',
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DailyCreatePage(
                                    classroomId: widget.classroomId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Drawer 닫기
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClassroomDailyPageTapBar(
                          classroomId: widget.classroomId,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget._isExpanded[0] ? null : 0, // 버튼 그룹 높이 조절
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('생활'),
                      Text('생활'),
                      Text('생활'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    child: Image.asset(
                      'assets/buttons/to-Down.png',
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    onTap: () {
                      setState(
                        () {
                          widget._isExpanded[1] =
                              !widget._isExpanded[1]; // 버튼 그룹 확장/축소 토글
                        },
                      );
                    },
                  ),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          const Text('태도'),
                          Spacer(),
                          GestureDetector(
                            child: Image.asset(
                              'assets/buttons/class_plus_button.jpg',
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttitudeCreatePage(
                                    classroomId: widget.classroomId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Drawer 닫기
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClassroomAttitudePageTapBar(
                          classroomId: widget.classroomId,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget._isExpanded[1] ? null : 0, // 버튼 그룹 높이 조절
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('생활'),
                      Text('생활'),
                      Text('생활'),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(),
            ListTile(
              leading: Image.asset('assets/buttons/to-Down.png',
                  width: MediaQuery.of(context).size.width * 0.03),
              title: Row(
                children: [
                  const Text('수업'),
                  Spacer(),
                  Image.asset(
                    'assets/buttons/class_plus_button.jpg',
                    width: MediaQuery.of(context).size.width * 0.01,
                  )
                ],
              ),
              onTap: () {
                // Todo
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('기능 미구현'),
                      content: const Text('해당 기능은 추가중입니다.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // 출석 체크 해제 로직 추가
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                Navigator.of(context).pop(); // Drawer 닫기
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => ClassroomClassesPageTapBar(
                //       classroomId: classroomId,
                //     ),
                //   ),
                // );
              },
            ),
            const Divider(),
            Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    child: Image.asset(
                      'assets/buttons/to-Down.png',
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    onTap: () {
                      setState(
                        () {
                          widget._isExpanded[2] =
                              !widget._isExpanded[2]; // 버튼 그룹 확장/축소 토글
                        },
                      );
                    },
                  ),
                  title: const Text('통계'),
                  onTap: () {
                    Navigator.of(context).pop(); // Drawer 닫기
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClassroomHistoryPage(
                          teacherUid: authProvider.currentUser()!.uid,
                          classroomId: widget.classroomId,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget._isExpanded[2] ? null : 0, // 버튼 그룹 높이 조절
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('생활'),
                      Text('생활'),
                      Text('생활'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
