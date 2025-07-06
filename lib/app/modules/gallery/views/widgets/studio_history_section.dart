import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class StudioHistorySection extends StatelessWidget {
  const StudioHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Studio History",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: SlectivColors.titleColor,
          ),
        ),
        const SizedBox(height: 16),

        _buildHistoryCard(
          icon: Icons.foundation_rounded,
          title: "Established Since 2020",
          content:
              "Slectiv Studio was founded with a vision to provide high-quality photography services with cutting-edge technology.",
          color: Colors.blue,
        ),

        const SizedBox(height: 16),

        _buildHistoryCard(
          icon: Icons.trending_up_rounded,
          title: "Rapid Growth",
          content:
              "With dedication and commitment to quality, we have served thousands of clients with maximum satisfaction.",
          color: Colors.green,
        ),

        const SizedBox(height: 16),

        _buildHistoryCard(
          icon: Icons.emoji_events_rounded,
          title: "Best Achievements",
          content:
              "We are proud to be one of the trusted photography studios with international professional standards.",
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildHistoryCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: SlectivColors.textGray,
                    height: 1.5,
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
