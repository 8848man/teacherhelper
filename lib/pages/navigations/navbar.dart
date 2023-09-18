import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/classroom_attitude_page_tapbar.dart';
import 'package:teacherhelper/pages/classes/classroom_classes_page.dart/classroom_classes_page_tapbar.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_page_tapbar.dart';
import 'package:teacherhelper/pages/main_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';

class NavBar extends StatelessWidget {
  final String classroomId;
  const NavBar({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<ClassroomProvider>(
          builder: (context, classroomProvider, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('선생님 이름 : '),
              accountEmail: const Text('반 이름 : '),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('images/profile.jpg'),
                ),
              ),
              decoration: const BoxDecoration(
                  color: Colors.pink,
                  image: DecorationImage(
                      image: AssetImage('images/back.jpg'), fit: BoxFit.cover)),
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
              leading: const Icon(Icons.calendar_month),
              title: const Text('생활'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClassroomDailyPageTapBar(
                      classroomId: classroomId,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('태도'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClassroomAttitudePageTapBar(
                      classroomId: classroomId,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_outlined),
              title: const Text('수업'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClassroomClassesPageTapBar(
                      classroomId: classroomId,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
