import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_page_tapbar.dart';
// import 'package:teacherhelper/pages/classes/create_classroom_page.dart';
import 'package:teacherhelper/pages/classes/classroom_create_page.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

// class MainPage extends HookWidget {
//   User? user = FirebaseAuth.instance.currentUser;

//   MainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final classroomProvider = Provider.of<ClassroomProvider>(context);

//     final classrooms = classroomProvider.classrooms;
//     final currentUserUid = AuthService().currentUser()?.uid.toString();

//     useEffect(() {
//       classroomProvider.fetchClassrooms(currentUserUid!);
//       return null;
//     }, []);

//     return Consumer<AuthService>(
//       builder: (context, authService, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("${user!.email}님 안녕하세요"),
//             actions: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.logout),
//                     onPressed: () {
//                       authService.signOut;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginPage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           body: Consumer<ClassroomProvider>(
//             builder: (context, classroomProvider, child) {
//               return ListView.builder(
//                 itemCount: classrooms.length,
//                 itemBuilder: (context, index) {
//                   final classroom = classrooms[index];
//                   return ListTile(
//                     title: Text(classroom.name),
//                     subtitle: Text("학년: ${classroom.grade}"),
//                     onTap: () {
//                       Provider.of<ClassroomProvider>(context, listen: false)
//                           .setClassroomId(classroom.uid!);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ClassroomDailyPageTapBar(
//                               classroomId: classroom.uid!),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//           floatingActionButton: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               FloatingActionButton(
//                 onPressed: () {
//                   // Handle first button's action
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ClassroomRegistPage(teacherUid: user!.uid),
//                     ),
//                   );
//                 },
//                 tooltip: '반 추가하기',
//                 child: const Icon(Icons.add), // Tooltip에 표시할 텍스트
//               ),
//               const SizedBox(height: 16),
//               FloatingActionButton(
//                 onPressed: () {
//                   // Handle second button's action
//                 },
//                 child: const Icon(Icons.delete),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class MainPage_reform extends StatefulWidget {
  const MainPage_reform({super.key});

  @override
  State<MainPage_reform> createState() => _MainPage_reformState();
}

class _MainPage_reformState extends State<MainPage_reform> {
  User? user = FirebaseAuth.instance.currentUser;

  // 데이터를 가져왔는지에 대한 여부.
  bool _dataFetched = false;
  @override
  void initState() {
    super.initState();
    fetchData();
    // 여기에서 초기화 작업 수행
  }

  final currentUserUid = AuthService().currentUser()?.uid.toString();

  Future<void> fetchData() async {
    try {
      final classroomProvider =
          Provider.of<ClassroomProvider>(context, listen: false);

      classroomProvider.fetchClassrooms(currentUserUid!);
      _dataFetched = true;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // final classroomProvider = Provider.of<ClassroomProvider>(context);

    // final classrooms = classroomProvider.classrooms;

    // useEffect(() {
    //   classroomProvider.fetchClassrooms(currentUserUid!);
    // }, []);

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          body: Consumer<ClassroomProvider>(
            builder: (context, classroomProvider, child) {
              final List<Classroom> classrooms = classroomProvider.classrooms;
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
                        itemCount: classrooms.length + 1,
                        itemBuilder: ((context, index) {
                          // 인덱스 에러 방지 삼항연산자
                          final classroom = classrooms.isEmpty
                              // classrooms가 비어있을 때 에러 방지를 위한 더미데이터
                              ? Classroom(
                                  name: '',
                                  teacherUid: '',
                                )
                              : index == classrooms.length
                                  ? classrooms[index - 1]
                                  : classrooms[index];
                          if (index == classrooms.length) {
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
                                    GestureDetector(
                                      child: Image.asset(
                                          'assets/buttons/modify_button.jpg'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClassroomRegistPage_reform(
                                              teacherUid: user!.uid,
                                              isModify: true,
                                              classroomId: classroom.uid,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClassroomDailyPageTapBar(
                                            classroomId: classroom.uid!),
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
            },
          ),
          // floatingActionButton: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     FloatingActionButton(
          //       onPressed: () {
          //         // Handle first button's action
          //         Navigator.push(

          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 ClassroomRegistPage_reform(teacherUid: user!.uid),
          //           ),
          //         );
          //       },
          //       child: Icon(Icons.add),
          //       tooltip: '반 추가하기', // Tooltip에 표시할 텍스트
          //     ),
          //     SizedBox(height: 16),
          //     FloatingActionButton(
          //       onPressed: () {
          //         // Handle second button's action
          //       },
          //       child: Icon(Icons.delete),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }
}
