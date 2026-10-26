import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DayFreshLogo extends StatelessWidget {
  final double scale;
  final bool isDarkBackground;

  const DayFreshLogo({
    super.key,
    this.scale = 1.0,
    this.isDarkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Day',
                style: GoogleFonts.poppins(
                  color: AppColors.logoDayRed,
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Fresh',
                style: GoogleFonts.poppins(
                  color: AppColors.logoFreshGreen,
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        Text(
          'HYPERMARKET',
          style: GoogleFonts.plusJakartaSans(
            color: isDarkBackground ? Colors.white.withValues(alpha: 0.9) : AppColors.textDark,
            fontSize: 7.5 * scale,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }
}
