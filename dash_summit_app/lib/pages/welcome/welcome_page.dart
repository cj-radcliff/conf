import 'package:dash_summit_app/pages/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF135bec),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        '<svg class="h-8 w-8 text-white" fill="none" viewbox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path></svg>',
                        width: 32,
                        height: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dash Summit',
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111318),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Guide to the 2-Day Tech Conference.',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: const Color(0xFF616f89),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Welcome! This app is your essential companion to navigate sessions, connect with peers, and maximize your summit experience.',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: const Color(0xFF111318),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(title: 'Dates', value: 'Oct 26-27'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      title: 'Location',
                      value: 'Conference Center',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _FeatureCard(
                    icon: Icons.calendar_month,
                    title: 'Full Agenda',
                    description:
                        'Explore keynotes, breakouts, and sessions across both tracks.',
                  ),
                  _FeatureCard(
                    icon: Icons.schedule,
                    title: 'Personalized Schedule',
                    description:
                        'Build your custom itinerary and get session reminders.',
                  ),
                  _FeatureCard(
                    icon: Icons.group,
                    title: 'Speaker Profiles',
                    description:
                        'Learn more about our industry-leading speakers.',
                  ),
                  _FeatureCard(
                    icon: Icons.chat,
                    title: 'Networking',
                    description: 'Connect with fellow attendees and sponsors.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SchedulePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF135bec),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'View Full Agenda',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFdbdfe6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: const Color(0xFF616f89),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111318),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFdbdfe6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF135bec).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF135bec)),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111318),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              description,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: const Color(0xFF616f89),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
