import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/widgets/dialogs/dialogs.dart';

import '../providers/classroom_provider.dart';
import '../providers/loading_provider.dart';
import '../providers/new_daily_provider.dart';
import '../providers/new_layout_provider.dart';
import '../providers/new_lesson_provider.dart';
import '../providers/new_student_provider.dart';

// 바텀 네비게이션
Widget layoutBottomNavigation(BuildContext context, String classroomId) {
  final layoutProvider = Provider.of<NewLayoutProvider>(context, listen: false);
  List<String> navbarImages = layoutProvider.getNavbarImages();
  final studentProvider =
      Provider.of<NewStudentProvider>(context, listen: false);
  final lessonProvider = Provider.of<NewLessonProvider>(context, listen: false);
  final dailyProvider = Provider.of<NewDailyProvider>(context, listen: false);
  final classroomProvider =
      Provider.of<ClassroomProvider>(context, listen: false);
  final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

  print('classroom Id is ${classroomProvider.classroom.uid}');

  return Container(
    width: double.infinity,
    height: 90,
    color: const Color(0xFF344054),
    child: Row(
      children: [
        const SizedBox(
          width: 90,
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[0]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(0);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[1]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(1);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[2]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(2);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            // 수업, 일상 추가 버튼
            child: GestureDetector(
              child: Image.asset(
                  'assets/icons_for_bottomnav/dailys/plus_button.png'),
              onTap: () async {
                if (layoutProvider.selectedIndices[2] == 1) {
                  loadingProvider.setLoading(true);
                  String dailyName = '일상';
                  showCreateDailyDialog(context, dailyName, classroomId);
                  // await layoutProvider.createDailyLayout(
                  //     classroomProvider.classroom,
                  //     studentProvider.students);
                  loadingProvider.setLoading(false);
                } else if (layoutProvider.selectedIndices[3] == 1) {
                  print('수업 추가');
                }
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[3]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(3);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[4]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(4);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        child: Image.asset(navbarImages[5]),
                        onTap: () {
                          layoutProvider.setSelectedBottomNav(5);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 90),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Image.asset(navbarImages[6]),
        ),
      ],
    ),
  );
}
