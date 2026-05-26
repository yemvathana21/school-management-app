import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/announcement_model.dart';
import 'package:psbu_app/core/models/attendance_model.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/providers/announcement_provider.dart';
import 'package:psbu_app/core/providers/attendance_provider.dart';
import 'package:psbu_app/core/providers/schedule_provider.dart';

class HomeScreen extends ConsumerWidget {
  final UserModel? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);
    final schedulesAsync = ref.watch(schedulesProvider);
    final attendancesAsync = ref.watch(attendancesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(announcementsProvider.future),
          ref.refresh(schedulesProvider.future),
        ]),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              announcementsAsync.when(
                data: (data) => _buildAnnouncements(context, data),
                loading: () => const SizedBox(height: 180),
                error: (_, _) => const SizedBox(height: 180),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Schedule",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              schedulesAsync.when(
                data: (data) => _buildScheduleList(context, data),
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Failed to load schedule',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ),
              ),
              attendancesAsync.when(
                data: (attendances) => _buildAttendanceStats(context, attendances),
                loading: () => const SizedBox(height: 80),
                error: (_, _) => const SizedBox(height: 80),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              _buildQuickAccess(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateStr = '${dayNames[now.weekday - 1]}, ${now.day} ${monthNames[now.month - 1]} ${now.year}';
    final greetings = ['Good Morning', 'Good Afternoon', 'Good Evening'];
    final hour = now.hour;
    final greeting = hour < 12 ? greetings[0] : (hour < 17 ? greetings[1] : greetings[2]);

    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        (user?.name.isNotEmpty == true ? user!.name[0] : 'S').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.name ?? 'Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                dateStr,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncements(BuildContext context, List<AnnouncementModel> announcements) {
    if (announcements.isEmpty) return const SizedBox(height: 12);

    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFA726),
    ];

    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: announcements.length > 4 ? 4 : announcements.length,
        itemBuilder: (context, index) {
          final ann = announcements[index];
          final color = colors[index % colors.length];
          return Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 20 : 0,
              right: 8,
              top: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.campaign, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ann.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ann.content,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ann.author?.name ?? '',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context, List<ScheduleModel> schedules) {
    final reverseMapping = <int, String>{
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
    };

    final todayName = reverseMapping[DateTime.now().weekday] ?? '';
    final todaySchedules = schedules
        .where((s) => s.day == todayName)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    if (todaySchedules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Text('No classes today', style: TextStyle(color: Colors.grey.shade500)),
              Text(
                'Enjoy your day off!',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(todaySchedules.length, (index) {
          final s = todaySchedules[index];
          final isOngoing = _isOngoing(s.startTime, s.endTime);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Column(
                    children: [
                      Text(
                        s.startTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isOngoing
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: isOngoing
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade200,
                      ),
                      Text(
                        s.endTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isOngoing
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isOngoing
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                            : Colors.grey.shade200,
                        width: isOngoing ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isOngoing
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCourseIcon(s.course?.name ?? ''),
                            color: isOngoing ? Colors.white : Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.course?.name ?? 'Course',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isOngoing
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${s.room ?? ''}  \u2022  ${s.teacher?.name ?? ''}',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (isOngoing)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool _isOngoing(String startTime, String endTime) {
    final now = DateTime.now();
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');
    final startMin = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMin = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    final nowMin = now.hour * 60 + now.minute;
    return nowMin >= startMin && nowMin < endMin;
  }

  IconData _getCourseIcon(String courseName) {
    final name = courseName.toLowerCase();
    if (name.contains('math')) return Icons.functions;
    if (name.contains('phys')) return Icons.science;
    if (name.contains('eng')) return Icons.translate;
    if (name.contains('bio')) return Icons.biotech;
    if (name.contains('comp') || name.contains('info')) return Icons.computer;
    return Icons.book;
  }

  Widget _buildAttendanceStats(BuildContext context, List<AttendanceModel> attendances) {
    final total = attendances.length;
    final present = attendances.where((a) => a.status == 'present').length;
    final percentage = total > 0 ? (present / total * 100).toStringAsFixed(0) : '100';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$percentage%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                      Text('Attendance', style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Text('Total Days', style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final items = [
      ('Grades', Icons.grade_rounded, const Color(0xFF6C63FF)),
      ('Schedule', Icons.calendar_month_rounded, const Color(0xFF4ECDC4)),
      ('Classes', Icons.people_rounded, const Color(0xFFFFA726)),
      ('Attendance', Icons.qr_code_scanner_rounded, const Color(0xFFFF6B6B)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 74,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: item.$3.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.$3.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.$2, color: item.$3, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$1,
                    style: TextStyle(
                      color: item.$3,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
