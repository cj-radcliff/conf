import 'package:dash_summit_app/models/session.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F8),
        body: Column(
          children: [
            const _ScheduleHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  _DayScheduleView(dayIndex: 0),
                  _DayScheduleView(dayIndex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F8), // background-light
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F2937),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Conference Schedule',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF1F2937),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TabBar(
                labelColor: Color(0xFF135BEC),
                unselectedLabelColor: Color(0xFF6B7280),
                indicatorColor: Color(0xFF135BEC),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Day 1 (Oct 26)'),
                  Tab(text: 'Day 2 (Oct 27)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayScheduleView extends StatelessWidget {
  final int dayIndex;

  const _DayScheduleView({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    // Oct 26 is Day 1, Oct 27 is Day 2
    final targetDate = DateTime(2025, 10, 26 + dayIndex);

    // Dummy data for UI verification
    final sessions = [
      Session(
        id: '1',
        title: 'Keynote: The Future of Flutter',
        speaker: 'Dash',
        startTime: DateTime(2025, 10, 26, 9, 0),
        endTime: DateTime(2025, 10, 26, 10, 0),
        room: 'Main Hall',
        track: 'General',
        description: 'Join us for the opening keynote.',
        isKeynote: true,
        imageUrl: 'assets/images/keynote.png',
      ),
      Session(
        id: '2',
        title: 'Building Beautiful UIs',
        speaker: 'Flutter Team',
        startTime: DateTime(2025, 10, 26, 10, 15),
        endTime: DateTime(2025, 10, 26, 11, 0),
        room: 'Room A',
        track: 'UI/UX',
        description: 'Learn how to build stunning UIs with Flutter.',
        isFavorite: true,
      ),
      Session(
        id: '3',
        title: 'State Management Patterns',
        speaker: 'Community Expert',
        startTime: DateTime(2025, 10, 26, 10, 15),
        endTime: DateTime(2025, 10, 26, 11, 0),
        room: 'Room B',
        track: 'Architecture',
        description: 'Explore different state management approaches.',
      ),
      Session(
        id: '4',
        title: 'Lunch Break',
        speaker: '',
        startTime: DateTime(2025, 10, 26, 12, 0),
        endTime: DateTime(2025, 10, 26, 13, 0),
        room: 'Cafeteria',
        track: 'Break',
        description: 'Enjoy a delicious lunch.',
      ),
    ];

    final daySessions = sessions.where((s) {
      return s.startTime.year == targetDate.year &&
          s.startTime.month == targetDate.month &&
          s.startTime.day == targetDate.day;
    }).toList();

    if (daySessions.isEmpty) {
      return const Center(child: Text('No sessions scheduled for this day.'));
    }

    final timeSlots = <DateTime, List<Session>>{};
    for (var session in daySessions) {
      final time = session.startTime;
      if (!timeSlots.containsKey(time)) {
        timeSlots[time] = [];
      }
      timeSlots[time]!.add(session);
    }

    final sortedTimes = timeSlots.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sortedTimes.length,
      itemBuilder: (context, index) {
        final time = sortedTimes[index];
        final slotSessions = timeSlots[time]!;
        final endTime = slotSessions.first.endTime;
        final timeString =
            '${DateFormat.jm().format(time)} - ${DateFormat.jm().format(endTime)}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimeSlotHeader(time: timeString),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: slotSessions.map((session) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSessionCard(session),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(Session session) {
    if (session.isKeynote) {
      return _KeynoteCard(session: session);
    } else if (session.title.contains('Break') ||
        session.title.contains('Lunch')) {
      return _BreakCard(
        title: session.title,
        location: session.room,
        icon: session.title.contains('Lunch') ? Icons.restaurant : Icons.coffee,
        color: session.title.contains('Lunch') ? Colors.green : Colors.brown,
      );
    } else if (session.title.contains('Breakout')) {
      return const _BreakoutCard();
    } else {
      return _TalkCard(
        track: session.track,
        trackColor: _getTrackColor(session.track),
        title: session.title,
        speaker: session.speaker,
        room: session.room,
        isFavorite: session.isFavorite,
      );
    }
  }

  Color _getTrackColor(String track) {
    if (track.contains('Design')) return Colors.orange;
    if (track.contains('Engineering')) return Colors.purple;
    return Colors.blue;
  }
}

class _TimeSlotHeader extends StatelessWidget {
  final String time;

  const _TimeSlotHeader({required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _KeynoteCard extends StatelessWidget {
  final Session session;
  const _KeynoteCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            session.imageUrl,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 160,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KEYNOTE',
                  style: TextStyle(
                    color: Color(0xFF135BEC),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.speaker,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          session.room,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.star_outline,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TalkCard extends StatelessWidget {
  final String track;
  final Color trackColor;
  final String title;
  final String speaker;
  final String room;
  final bool isFavorite;

  const _TalkCard({
    required this.track,
    required this.trackColor,
    required this.title,
    required this.speaker,
    required this.room,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: trackColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: trackColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      track,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: trackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isFavorite
                      ? const Color(0xFF135BEC).withOpacity(0.2)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_outline,
                  color: isFavorite
                      ? const Color(0xFF135BEC)
                      : const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            speaker,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
          ),
          Text(
            room,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }
}

class _BreakCard extends StatelessWidget {
  final String title;
  final String location;
  final IconData icon;
  final Color color;

  const _BreakCard({
    required this.title,
    required this.location,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakoutCard extends StatelessWidget {
  const _BreakoutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF135BEC).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF135BEC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breakout Sessions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF135BEC),
                  ),
                ),
                Text(
                  'Choose your topics',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Color(0xFF135BEC)),
        ],
      ),
    );
  }
}
