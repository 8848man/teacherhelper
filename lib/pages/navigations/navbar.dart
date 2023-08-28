import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_attitude_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_classes_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_daily_page.dart';
import 'package:teacherhelper/pages/main_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';

class NavBar extends StatelessWidget {
  NavBar({super.key});

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
              leading: Icon(Icons.home),
              title: Text('홈으로'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('생활'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => ClassroomDailyPage1(
                            classroomId:
                                classroomProvider.classroomId.toString(),
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('태도'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => ClassroomAttitudePage(
                            classroomId:
                                classroomProvider.classroomId.toString(),
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.class_outlined),
              title: Text('수업'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => ClassroomClassesPage(
                            classroomId:
                                classroomProvider.classroomId.toString(),
                          )),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
