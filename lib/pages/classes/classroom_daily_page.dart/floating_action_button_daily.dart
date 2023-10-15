import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';

// 데일리 페이지 학생 추가, 과제 추가 버튼 모음
class FloatingActionButtonDaily extends StatefulWidget {
  final String classroomId;

  const FloatingActionButtonDaily({super.key, required this.classroomId});

  @override
  State<FloatingActionButtonDaily> createState() =>
      _FloatingActionButtonDailyState();
}

class _FloatingActionButtonDailyState extends State<FloatingActionButtonDaily> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isExpanded
                    ? MediaQuery.of(context).size.height * 0.5
                    : 0, // 버튼 그룹 높이 조절
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 여기서부터 Floating Action Buttons
                      // FloatingActionButton(
                      //   onPressed: () {
                      //     // Handle first button's action
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => StudentRegistrationPage(
                      //           classroomId: widget.classroomId,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   tooltip: '학생 등록하기',
                      //   child: const Icon(Icons.person_add_alt),
                      // ),
                      // const SizedBox(height: 16),
                      // FloatingActionButton(
                      //   onPressed: () {
                      //     // Handle second button's action
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => ClassroomStudentDeletePage(
                      //           classroomId: widget.classroomId,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   tooltip: '학생 삭제하기',
                      //   child: const Icon(Icons.person_remove_alt_1_outlined),
                      // ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        onPressed: () {
                          // Handle third button's action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DailyCreatePage(
                                classroomId: widget.classroomId,
                              ),
                            ),
                          );
                        },
                        tooltip: '일과 과제 등록하기',
                        child: const Icon(Icons.add_circle_outline),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        onPressed: () {
                          // Handle fourth button's action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassroomStudentDeletePage(
                                classroomId: widget.classroomId,
                              ),
                            ),
                          );
                        },
                        tooltip: '일과 과제 삭제하기',
                        child: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // 버튼 그룹 확장/축소 토글
                  });
                },
                child: Icon(_isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up), // 화살표 아이콘 토글
              ),
            ],
          ),
        ],
      ),
    );
  }
}
