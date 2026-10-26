import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/app_state.dart';
import '../screens/submitted_tasks_screen.dart';
import '../theme/app_theme.dart';

class TaskSuccessDialog extends StatelessWidget {
  final TaskItem task;
  final AppState state;
  final DateTime submissionTime;

  const TaskSuccessDialog({
    super.key,
    required this.task,
    required this.state,
    required this.submissionTime,
  });

  static Future<void> show({
    required BuildContext context,
    required TaskItem task,
    required AppState state,
    required DateTime submissionTime,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => TaskSuccessDialog(
        task: task,
        state: state,
        submissionTime: submissionTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('MMMM d, yyyy hh:mm a').format(submissionTime);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green circular checkmark
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FADF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_rounded,
                  color: Color(0xFF12B76A),
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Title
            Text(
              'Task Submitted!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Your task has been submitted\nsuccessfully.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Timestamp label and date
            Text(
              'Submitted on',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 28),

            // "View Submitted Task" button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // dismiss dialog
                  Navigator.of(context).pop(); // dismiss submit task screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubmittedTasksScreen(state: state),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Submitted Task',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // "Close" button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
                Navigator.of(context).pop(); // dismiss submit task screen
              },
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
