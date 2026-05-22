import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/providers/auth_provider.dart';
import 'package:psbu_app/features/student/screens/home_screen.dart';
import 'package:psbu_app/features/student/screens/schedule_screen.dart';
import 'package:psbu_app/features/student/screens/scan_screen.dart';
import 'package:psbu_app/features/student/screens/classes_screen.dart';
import 'package:psbu_app/features/student/screens/menu_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentShell extends ConsumerStatefulWidget {
  const StudentShell({super.key});

  @override
  ConsumerState<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends ConsumerState<StudentShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final storage = const FlutterSecureStorage();
    final userData = await storage.read(key: 'user_data');
    if (userData != null && mounted) {
      final user = UserModel.fromJson(
        jsonDecode(userData) as Map<String, dynamic>,
      );
      ref.read(authProvider.notifier).login(user.email, '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final user = auth.user;

    final screens = [
      HomeScreen(user: user),
      ScheduleScreen(user: user),
      ScanScreen(user: user),
      ClassesScreen(user: user),
      MenuScreen(user: user),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: theme.colorScheme.surface,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _navItem(
                Icons.calendar_month_outlined,
                Icons.calendar_month,
                'Schedule',
                1,
              ),
              const SizedBox(width: 48),
              _navItem(Icons.class_outlined, Icons.class_, 'Class', 3),
              _navItem(Icons.menu_outlined, Icons.menu, 'Menu', 4),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          Icons.qr_code_scanner,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navItem(IconData iconOutlined, IconData iconFilled, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? iconFilled : iconOutlined,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
