import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _announcementCard(
            'School Holiday',
            'School will be closed on Friday for national holiday.',
            'Admin',
            '2 hours ago',
          ),
          _announcementCard(
            'Exam Schedule',
            'Final exam schedule has been published. Please check.',
            'Academic Affairs',
            '1 day ago',
          ),
          _announcementCard(
            'Club Registration',
            'Club registration is open until end of month.',
            'Student Affairs',
            '3 days ago',
          ),
        ],
      ),
    );
  }

  Widget _announcementCard(String title, String content, String author, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(author, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
