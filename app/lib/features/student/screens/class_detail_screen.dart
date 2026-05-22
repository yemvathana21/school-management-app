import 'package:flutter/material.dart';
import 'package:psbu_app/core/models/schedule_model.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final c = classModel;
    final studentCount = c.students?.length ?? 0;
    final scheduleCount = c.schedules?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF),
                  const Color(0xFF4ECDC4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.class_, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  c.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  c.code,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat(Icons.person, 'Teacher', c.teacher?.name ?? 'N/A'),
                    _stat(Icons.people, 'Students', '$studentCount'),
                    _stat(Icons.calendar_month, 'Schedules', '$scheduleCount'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (c.description != null) ...[
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              c.description!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
          ],
          if (c.schedules != null && c.schedules!.isNotEmpty) ...[
            Text(
              'Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ...c.schedules!.map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.book, color: Color(0xFF6C63FF), size: 20),
                    ),
                    title: Text(s.course?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      '${s.day}  ${s.startTime}-${s.endTime}  ${s.room ?? ''}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                )),
          ],
          if (c.students != null && c.students!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Students ($studentCount)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ...c.students!.map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      child: Text(
                        s.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title: Text(s.name, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(s.nis ?? '', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10),
        ),
      ],
    );
  }
}
