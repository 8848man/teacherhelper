import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/cover_page.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/attitude_history_provider.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_history_provider.dart';
import 'package:teacherhelper/providers/student_attitude_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

import './services/auth_service.dart';
import 'providers/daily_provider.dart';

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
        ChangeNotifierProvider(create: (context) => DailyProvider()),
        ChangeNotifierProvider(create: (context) => DailyHistoryProvider()),
        ChangeNotifierProvider(create: (context) => AttitudeProvider()),
        ChangeNotifierProvider(create: (context) => AttitudeHistoryProvider()),
        ChangeNotifierProvider(create: (context) => StudentAttitudeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = context.read<AuthService>().currentUser();

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: user == null ? LoginPage() : HomePage(),
      home: CoverPage(),
    );
  }
}
