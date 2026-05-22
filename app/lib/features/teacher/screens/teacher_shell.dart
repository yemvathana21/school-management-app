import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/course_model.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/providers/attendance_provider.dart';
import 'package:psbu_app/core/providers/auth_provider.dart';
import 'package:psbu_app/core/providers/class_provider.dart';
import 'package:psbu_app/core/providers/grade_provider.dart';
import 'package:psbu_app/core/providers/schedule_provider.dart';
import 'package:psbu_app/core/repositories/attendance_repository.dart';
import 'package:psbu_app/core/repositories/grade_repository.dart';
import 'package:psbu_app/core/repositories/qr_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherShell extends ConsumerStatefulWidget {
  const TeacherShell({super.key});

  @override
  ConsumerState<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends ConsumerState<TeacherShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    final screens = [
      _DashboardTab(user: user),
      _AttendanceTab(user: user),
      _GradesTab(user: user),
      _MenuTab(user: user),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.grade_outlined),
            label: 'Grades',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  final UserModel? user;
  const _DashboardTab({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final classesAsync = ref.watch(classesProvider);
    final schedulesAsync = ref.watch(schedulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(classesProvider.future),
          ref.refresh(schedulesProvider.future),
        ]),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          (user?.name.isNotEmpty == true
                                  ? user!.name[0]
                                  : 'T')
                              .toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user?.name.split(' ')[0] ?? 'Teacher'}!',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            user?.name ?? 'Teacher',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              classesAsync.when(
                data: (classes) => schedulesAsync.when(
                  data: (schedules) {
                    final classCount = classes.length;
                    final studentCount =
                        classes.fold(0, (sum, c) => sum + (c.students?.length ?? 0));
                    final todaySchedules = schedules.where((s) {
                      final dayNames = {
                        DateTime.monday: 'Monday',
                        DateTime.tuesday: 'Tuesday',
                        DateTime.wednesday: 'Wednesday',
                        DateTime.thursday: 'Thursday',
                        DateTime.friday: 'Friday',
                      };
                      return s.day == dayNames[DateTime.now().weekday];
                    }).length;

                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _statCard(
                            Icons.class_, 'My Classes', classCount.toString(), Colors.blue),
                        _statCard(
                            Icons.people, 'Students', studentCount.toString(), Colors.green),
                        _statCard(Icons.calendar_today, "Today's Classes",
                            todaySchedules.toString(), Colors.orange),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load data',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
      IconData icon, String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTab extends ConsumerStatefulWidget {
  final UserModel? user;
  const _AttendanceTab({this.user});

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  String? _qrData;
  String? _qrCourse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendancesAsync = ref.watch(attendancesProvider);
    final schedulesAsync = ref.watch(schedulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(attendancesProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showQrDialog(context, schedulesAsync),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.qr_code,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Generate QR Code',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'For today\'s class attendance',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
            if (_qrData != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _qrCourse ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scan this QR to mark attendance',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              "Today's Attendance",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            attendancesAsync.when(
              data: (attendances) {
                final today = DateTime.now().toIso8601String().split('T')[0];
                final todayAttendance = attendances
                    .where((a) => a.date.startsWith(today))
                    .toList();

                if (todayAttendance.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No attendance records today',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  );
                }

                return Column(
                  children: todayAttendance.map((a) {
                    final statusColor = switch (a.status) {
                      'present' => Colors.green,
                      'late' => Colors.orange,
                      'absent' => Colors.red,
                      'excused' => Colors.blue,
                      _ => Colors.grey,
                    };
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              statusColor.withValues(alpha: 0.1),
                          child: Text(
                            (a.student?.name.isNotEmpty == true
                                    ? a.student!.name[0]
                                    : '?')
                                .toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(a.student?.name ?? 'Unknown'),
                        subtitle: Text(
                          a.schedule?.course?.name ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: DropdownButton<String>(
                          value: a.status,
                          underline: const SizedBox(),
                          items: ['present', 'late', 'absent', 'excused']
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(s)
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        s[0].toUpperCase() + s.substring(1),
                                        style: TextStyle(
                                          color: _statusColor(s),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) async {
                            if (value != null) {
                              await ref
                                  .read(attendanceRepositoryProvider)
                                  .updateAttendance(a.id, value);
                              ref.invalidate(attendancesProvider);
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Failed to load attendance',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'present' => Colors.green,
      'late' => Colors.orange,
      'absent' => Colors.red,
      'excused' => Colors.blue,
      _ => Colors.grey,
    };
  }

  void _showQrDialog(
      BuildContext context, AsyncValue<List<ScheduleModel>> schedulesAsync) {
    schedulesAsync.whenData((schedules) {
      final today = DateTime.now();
      final dayNames = {
        DateTime.monday: 'Monday',
        DateTime.tuesday: 'Tuesday',
        DateTime.wednesday: 'Wednesday',
        DateTime.thursday: 'Thursday',
        DateTime.friday: 'Friday',
      };
      final todayName = dayNames[today.weekday];
      final todaySchedules = schedules
          .where((s) => s.day == todayName)
          .toList();

      if (todaySchedules.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No classes today')),
        );
        return;
      }

      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Select Class for QR',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...todaySchedules.map((s) => ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text('${s.course?.name ?? ''}'),
                  subtitle: Text('${s.startTime} - ${s.endTime} | ${s.room ?? ''}'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final result = await ref
                          .read(qrRepositoryProvider)
                          .generateQr(s.id);
                      setState(() {
                        _qrData = result['qr_data'] as String;
                        _qrCourse =
                            '${result['course']} - ${result['class']}';
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to generate QR'),
                        ),
                      );
                    }
                  },
                )),
          ],
        ),
      );
    });
  }
}

class _GradesTab extends ConsumerStatefulWidget {
  final UserModel? user;
  const _GradesTab({this.user});

  @override
  ConsumerState<_GradesTab> createState() => _GradesTabState();
}

class _GradesTabState extends ConsumerState<_GradesTab> {
  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '100');
  final _noteController = TextEditingController();
  String _selectedType = 'assignment';
  int? _selectedStudentId;
  int? _selectedCourseId;

  @override
  void dispose() {
    _nameController.dispose();
    _scoreController.dispose();
    _maxScoreController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradesAsync = ref.watch(gradesProvider);
    final classesAsync = ref.watch(classesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(gradesProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Grade',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    classesAsync.when(
                      data: (classes) {
                        final students = classes
                            .expand((c) => c.students ?? [])
                            .toList();

                        return Column(
                          children: [
                            DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: 'Student',
                                border: OutlineInputBorder(),
                              ),
                              items: students
                                  .map((s) => DropdownMenuItem<int>(
                                        value: s.id,
                                        child: Text(s.name),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedStudentId = v),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: 'Course',
                                border: OutlineInputBorder(),
                              ),
                              items: classes
                                  .expand((c) => c.schedules ?? [])
                                  .map((s) => s.course)
                                  .whereType<CourseModel>()
                                  .toSet()
                                  .map((c) => DropdownMenuItem<int>(
                                        value: c.id,
                                        child: Text(c.name),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedCourseId = v),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Type',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'assignment', child: Text('Assignment')),
                                DropdownMenuItem(
                                    value: 'quiz', child: Text('Quiz')),
                                DropdownMenuItem(
                                    value: 'midterm', child: Text('Midterm')),
                                DropdownMenuItem(
                                    value: 'final', child: Text('Final')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedType = v);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _scoreController,
                                    decoration: const InputDecoration(
                                      labelText: 'Score',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _maxScoreController,
                                    decoration: const InputDecoration(
                                      labelText: 'Max Score',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _noteController,
                              decoration: const InputDecoration(
                                labelText: 'Note (optional)',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _submitGrade,
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) =>
                          const Text('Failed to load data'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Grade History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            gradesAsync.when(
              data: (grades) {
                if (grades.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No grades yet',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  );
                }
                return Column(
                  children: grades.map((g) {
                    final typeColors = {
                      'assignment': Colors.blue,
                      'quiz': Colors.green,
                      'midterm': Colors.orange,
                      'final': Colors.red,
                    };
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: (typeColors[g.type] ?? Colors.grey)
                              .withValues(alpha: 0.1),
                          child: Text(
                            g.type[0].toUpperCase(),
                            style: TextStyle(
                              color: typeColors[g.type] ?? Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(g.name),
                        subtitle: Text(
                          '${g.student?.name ?? ''} | ${g.course?.name ?? ''}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          '${g.score.toInt()}/${g.maxScore.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Failed to load grades',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitGrade() async {
    if (_selectedStudentId == null || _selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select student and course')),
      );
      return;
    }

    final score = double.tryParse(_scoreController.text);
    final maxScore = double.tryParse(_maxScoreController.text);

    if (score == null || maxScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid score values')),
      );
      return;
    }

    try {
      await ref.read(gradeRepositoryProvider).storeGrade(
            studentId: _selectedStudentId!,
            courseId: _selectedCourseId!,
            type: _selectedType,
            name: _nameController.text,
            score: score,
            maxScore: maxScore,
            note: _noteController.text.isNotEmpty
                ? _noteController.text
                : null,
          );
      ref.invalidate(gradesProvider);
      _nameController.clear();
      _scoreController.clear();
      _noteController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grade submitted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit grade')),
        );
      }
    }
  }
}

class _MenuTab extends ConsumerWidget {
  final UserModel? user;
  const _MenuTab({this.user});

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      (user?.name.isNotEmpty == true
                              ? user!.name[0]
                              : 'T')
                          .toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Teacher',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          user?.nip ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _menuItem(Icons.person_outline, 'My Profile', () {}),
          _menuItem(Icons.schedule, 'My Schedule', () {}),
          const Divider(),
          _menuItem(Icons.logout, 'Logout', () async {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            }
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label,
            style: color != null ? TextStyle(color: color) : null),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
