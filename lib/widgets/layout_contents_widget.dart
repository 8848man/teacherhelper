import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student_with_data.dart';

import '../providers/new_classroom_provider.dart';
import '../providers/new_daily_provider.dart';
import '../providers/new_layout_provider.dart';
import '../providers/new_lesson_provider.dart';
import '../providers/new_student_provider.dart';

Widget contentsWidget(Map<String, dynamic> data) {
  TextEditingController textController =
      TextEditingController(text: data['name']);
  return Consumer5<NewLayoutProvider, NewDailyProvider, NewLessonProvider,
          NewStudentProvider, NewClassroomProvider>(
      builder: (context, layoutProvider, dailyProvider, classesProvider,
          studentProvider, classroomProvider, child) {
    final List<StudentWithData> students = data['students'];
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            // color: Colors.amber,
            child: Row(children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 300,
                height: 200,
                // color: Colors.red,
                child: Text(
                  '${layoutProvider.nowIndex}  >  ${data['name']}',
                  style: TextStyle(
                    color: Color(0xFF667085),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 300,
                height: 200,
                // color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('assets/buttons/button_whole_off.png'),
                    SizedBox(width: 15),
                    Image.asset('assets/buttons/button_whole_on.png'),
                    Image.asset('assets/buttons/button_option.png'),
                  ],
                ),
              ),
            ]),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            // color: Colors.orange,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 500,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // 둥근 테두리 설정
                  border: Border.all(
                      width: 1.0, color: Colors.black), // 테두리 선 스타일 설정
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: textController,
                          style: const TextStyle(fontSize: 30),
                          decoration: const InputDecoration(
                            hintText: '수정하고싶은 이름 입력',
                            border: InputBorder.none, // 밑줄 제거
                            focusedBorder: InputBorder.none, // 포커스된 상태에서 밑줄 제거
                          ),
                        ),
                      ),
                      //체크박스 넣을 공간
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset('assets/buttons/check_button.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // 학생들 정렬
        Expanded(
          flex: 15,
          child: Container(
            // color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 15, 70, 15),
              child: Container(
                // color: Colors.blue,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.7,
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: students.length >= 20 ? 10 : 5,
                        crossAxisSpacing: students.length >= 20
                            ? MediaQuery.of(context).size.width * 0.018
                            : 100,
                        mainAxisSpacing: students.length >= 20
                            ? MediaQuery.of(context).size.height * 0.03
                            : 100,
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return GestureDetector(
                          child: Card(
                            color: student.student.isCheked == true
                                ? const Color(0xFFD5EC48)
                                : const Color(0xFFEAECF0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(student.student.number.toString()),
                                Text(student.student.name),
                                // Text(student.student.isCheked as String),
                              ],
                            ),
                          ),
                          onTap: () {
                            student.student.isCheked =
                                !student.student.isCheked!;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  });
}
