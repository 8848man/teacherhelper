import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/pages/classes/classroom_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_modify_page.dart';
import 'package:teacherhelper/providers/new_classroom_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

import 'layout/new_layout_classroom.dart';

class NewMainPageReform extends StatefulWidget {
  const NewMainPageReform({super.key});

  @override
  State<NewMainPageReform> createState() => _NewMainPageReformState();
}

class _NewMainPageReformState extends State<NewMainPageReform> {
  User? user = FirebaseAuth.instance.currentUser;

  // 데이터를 가져왔는지에 대한 여부.
  @override
  void initState() {
    super.initState();
  }

  final currentUserUid = AuthService().currentUser()?.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NewClassroomProvider>(
          builder: (context, classroomProvider, child) {
        List<Classroom> newClassrooms = classroomProvider.classrooms;
        return FutureBuilder(
            future: classroomProvider.getClassroomsByTeacherId(currentUserUid!),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Container(
                    // color: Colors.yellow,
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    height: MediaQuery.of(context).size.height * 0.2,
                    // 상단의 텍스트 컨테이너
                    child: Container(
                      child: const Text(
                        '학반 등록 및 선택',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 48.0,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: 1.0,
                          // textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  // 카드 컨테이너를 위한 패딩
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.05,
                        0,
                        MediaQuery.of(context).size.height * 0.05,
                        MediaQuery.of(context).size.height * 0.05),
                    // 카드들을 위한 패딩
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xFFFFE8E0), // 색상 코드를 Color 클래스로 변환하여 사용
                      ),
                      // 카드 생성 그리드뷰
                      child: GridView.builder(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.05),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: newClassrooms.length + 1,
                        itemBuilder: ((context, index) {
                          // 인덱스 에러 방지 삼항연산자
                          final classroom = newClassrooms.isEmpty
                              // classrooms가 비어있을 때 에러 방지를 위한 더미데이터
                              ? Classroom(
                                  name: '',
                                  teacherUid: '',
                                )
                              : index == newClassrooms.length
                                  ? newClassrooms[index - 1]
                                  : newClassrooms[index];
                          if (index == newClassrooms.length) {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(70)),
                                  color:
                                      Colors.white, // 색상 코드를 Color 클래스로 변환하여 사용
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // 그림자 색상
                                      spreadRadius: 1, // 그림자 확산 정도
                                      blurRadius: 7, // 그림자 흐림 정도
                                      offset:
                                          const Offset(0, 3), // 그림자 위치 (수평, 수직)
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                    'assets/buttons/class_plus_button.jpg'),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClassroomRegistPage_reform(
                                      teacherUid: user!.uid,
                                      isModify: false,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(70)),
                                  color:
                                      Colors.white, // 색상 코드를 Color 클래스로 변환하여 사용
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // 그림자 색상
                                      spreadRadius: 1, // 그림자 확산 정도
                                      blurRadius: 7, // 그림자 흐림 정도
                                      offset:
                                          const Offset(0, 3), // 그림자 위치 (수평, 수직)
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      classroom.name,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                        fontWeight: FontWeight.w700,
                                        height: 4.0, // 라인 높이 조절
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                    ),
                                    // 수정하기 버튼
                                    GestureDetector(
                                      child: Image.asset(
                                          'assets/buttons/modify_button.jpg'),
                                      onTap: () {
                                        // classroomProvider.setClassroom(classroom);
                                        // 반 수정 페이지
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClassroomModifyPage(
                                              teacherUid: user!.uid,
                                              isModify: true,
                                              classroomId: classroom.uid!,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                // classroomProvider.setClassroom(classroom);
                                if (classroom.uid != null) {
                                  classroomProvider.fetchClassroomByClassroomId(
                                      classroom.uid!);
                                } else {
                                  print('classroomUid is null');
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NewLayoutClassroom(),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}
