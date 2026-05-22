import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/providers/auth_provider.dart';
import 'package:psbu_app/features/student/screens/assignments_screen.dart';
import 'package:psbu_app/features/student/screens/grades_screen.dart';
import 'package:psbu_app/features/student/screens/profile_screen.dart';
import 'package:psbu_app/features/student/screens/settings_screen.dart';

class MenuScreen extends ConsumerWidget {
  final UserModel? user;
  const MenuScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        (user?.name.isNotEmpty == true ? user!.name[0] : 'S').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Student',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          user?.nis ?? '',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.7)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Academic'),
          _menuItem(
            Icons.grade_rounded, 'My Grades', () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const GradesScreen()),
            ), const Color(0xFF6C63FF)),
          _menuItem(
            Icons.calendar_month_rounded, 'Schedule', () {}, const Color(0xFF4ECDC4)),
          _menuItem(
            Icons.assignment_rounded, 'Assignments', () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AssignmentsScreen()),
            ), const Color(0xFFFFA726)),
          _menuItem(
            Icons.bar_chart_rounded, 'Attendance Report', () {}, const Color(0xFF42A5F5)),
          const SizedBox(height: 16),
          _sectionTitle('General'),
          _menuItem(
            Icons.settings_rounded, 'Settings', () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ), Colors.grey),
          _menuItem(Icons.help_rounded, 'Help', () {}, Colors.grey),
          const SizedBox(height: 16),
          _menuItem(
            Icons.logout_rounded,
            'Logout',
            () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(label, style: TextStyle(color: color == Colors.red ? Colors.red : null)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        onTap: onTap,
      ),
    );
  }
}
