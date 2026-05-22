import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psbu_app/core/theme.dart';
import 'package:psbu_app/features/auth/screens/login_screen.dart';
import 'package:psbu_app/features/auth/screens/splash_screen.dart';
import 'package:psbu_app/features/student/screens/student_shell.dart';
import 'package:psbu_app/features/teacher/screens/teacher_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('app_cache');
  runApp(const ProviderScope(child: PSBUApp()));
}

class PSBUApp extends StatelessWidget {
  const PSBUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSBU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/student': (context) => const StudentShell(),
        '/teacher': (context) => const TeacherShell(),
      },
    );
  }
}
