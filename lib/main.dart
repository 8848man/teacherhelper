import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

import './services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(); // firebase 앱 시작
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        ChangeNotifierProvider(create: (context) => ClassroomProvider()),
        ChangeNotifierProvider(create: (context) => AssignmentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: user == null ? LoginPage() : HomePage(),
      home: LoginPage1(),
    );
  }
}

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();
        return Scaffold(
          appBar: AppBar(title: Text("로그인")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    user == null ? "로그인해 주세요 🙂" : "${user.email}님 안녕하세요 👋",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "이메일"),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: true, // 비밀번호 안보이게
                  decoration: InputDecoration(hintText: "비밀번호"),
                ),
                SizedBox(height: 32),

                /// 회원가입 버튼
                ElevatedButton(
                  child: Text("회원가입", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 회원가입
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 회원가입 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),

                ElevatedButton(
                  child: Text("테스트페이지로2", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 로그인
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage1()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// /// 홈페이지
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController jobController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BucketService>(
//       builder: (context, bucketService, child) {
//         final authService = context.read<AuthService>();
//         final user = authService.currentUser()!;
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("버킷 리스트"),
//             actions: [
//               TextButton(
//                 child: Text(
//                   "로그아웃",
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//                 onPressed: () {
//                   // 로그아웃
//                   context.read<AuthService>().signOut();
//                   // 로그인 페이지로 이동
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               /// 입력창
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   children: [
//                     /// 텍스트 입력창
//                     Expanded(
//                       child: TextField(
//                         controller: jobController,
//                         decoration: InputDecoration(
//                           hintText: "하고 싶은 일을 입력해주세요.",
//                         ),
//                       ),
//                     ),

//                     /// 추가 버튼
//                     ElevatedButton(
//                       child: Icon(Icons.add),
//                       onPressed: () {
//                         // create bucket
//                         if (jobController.text.isNotEmpty) {
//                           bucketService.create(jobController.text, user.uid);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(height: 1),

//               /// 버킷 리스트
//               Expanded(
//                 child: FutureBuilder<QuerySnapshot>(
//                     future: bucketService.read(user.uid),
//                     builder: (context, snapshot) {
//                       final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
//                       if (docs.isEmpty) {
//                         return Center(child: Text("버킷 리스트를 작성해주세요."));
//                       }
//                       return ListView.builder(
//                         itemCount: docs.length,
//                         itemBuilder: (context, index) {
//                           final doc = docs[index];
//                           String job = doc.get('job');
//                           bool isDone = doc.get('isDone');
//                           return ListTile(
//                             title: Text(
//                               job,
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 color: isDone ? Colors.grey : Colors.black,
//                                 decoration: isDone
//                                     ? TextDecoration.lineThrough
//                                     : TextDecoration.none,
//                               ),
//                             ),
//                             // 삭제 아이콘 버튼
//                             trailing: IconButton(
//                               icon: Icon(CupertinoIcons.delete),
//                               onPressed: () {
//                                 // 삭제 버튼 클릭시
//                                 bucketService.delete(doc.id);
//                               },
//                             ),
//                             onTap: () {
//                               // 아이템 클릭하여 isDone 업데이트
//                               bucketService.update(doc.id, !isDone);
//                             },
//                           );
//                         },
//                       );
//                     }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
