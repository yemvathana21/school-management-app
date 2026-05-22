import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/providers/auth_provider.dart';
import 'package:psbu_app/features/student/screens/home_screen.dart';
import 'package:psbu_app/features/student/screens/schedule_screen.dart';
import 'package:psbu_app/features/student/screens/scan_screen.dart';
import 'package:psbu_app/features/student/screens/classes_screen.dart';
import 'package:psbu_app/features/student/screens/menu_screen.dart';

class StudentShell extends ConsumerWidget {
  const StudentShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return _StudentShellContent(user: user, theme: theme);
  }
}

class _StudentShellContent extends StatefulWidget {
  final dynamic user;
  final ThemeData theme;

  const _StudentShellContent({required this.user, required this.theme});

  @override
  State<_StudentShellContent> createState() => _StudentShellContentState();
}

class _StudentShellContentState extends State<_StudentShellContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(user: widget.user),
      ScheduleScreen(user: widget.user),
      ScanScreen(user: widget.user),
      ClassesScreen(user: widget.user),
      MenuScreen(user: widget.user),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: widget.theme.colorScheme.surface,
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
        backgroundColor: widget.theme.colorScheme.primary,
        child: Icon(
          Icons.qr_code_scanner,
          color: widget.theme.colorScheme.onPrimary,
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
