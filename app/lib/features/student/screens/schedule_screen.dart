import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psbu_app/core/models/schedule_model.dart';
import 'package:psbu_app/core/models/user_model.dart';
import 'package:psbu_app/core/providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  final UserModel? user;
  const ScheduleScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        centerTitle: true,
      ),
      body: schedulesAsync.when(
        data: (schedules) => _buildView(context, schedules),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load schedule')),
      ),
    );
  }

  Widget _buildView(BuildContext context, List<ScheduleModel> schedules) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return DefaultTabController(
      length: days.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: false,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            tabs: days.map((d) => Tab(text: d.substring(0, 3))).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: days.map((day) {
                final daySchedules = schedules
                    .where((s) => s.day == day)
                    .toList()
                  ..sort((a, b) => a.startTime.compareTo(b.startTime));

                if (daySchedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No classes', style: TextStyle(color: Colors.grey.shade500)),
                        Text(
                          'Check back later',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daySchedules.length,
                  itemBuilder: (context, index) {
                    final s = daySchedules[index];
                    final colors = [
                      const Color(0xFF6C63FF),
                      const Color(0xFFFF6B6B),
                      const Color(0xFF4ECDC4),
                      const Color(0xFFFFA726),
                      const Color(0xFF42A5F5),
                    ];
                    final color = colors[index % colors.length];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        _getIcon(s.course?.name ?? ''),
                                        color: color,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.course?.name ?? 'Course',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${s.startTime} - ${s.endTime}',
                                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${s.room ?? 'N/A'}  \u{2022}  ${s.teacher?.name ?? ''}',
                                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        s.class_?.code ?? '',
                                        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('math')) return Icons.functions;
    if (n.contains('phys')) return Icons.science;
    if (n.contains('eng')) return Icons.translate;
    if (n.contains('bio')) return Icons.biotech;
    if (n.contains('comp') || n.contains('info')) return Icons.computer;
    return Icons.book;
  }
}
