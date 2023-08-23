import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_daily_page.dart';
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
              accountName: const Text('테스트네임'),
              accountEmail: const Text('테스트이메일'),
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
              onTap: () => print('home tapped'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('생활${classroomProvider.classroomId.id.toString()}'),
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ClassroomDailyPage1(
                            classroomId:
                                classroomProvider.classroomId.id.toString(),
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('태도'),
              onTap: () => print('attitude tapped'),
            ),
            ListTile(
              leading: Icon(Icons.class_outlined),
              title: Text('수업'),
              onTap: () => print('class tapped'),
            ),
          ],
        );
      }),
    );
  }
}
