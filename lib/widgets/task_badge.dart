import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    String label;

    switch (priority) {
      case TaskPriority.high:
        label = 'High';
        textColor = AppColors.priorityHighText;
        bgColor = AppColors.priorityHighBg;
        break;
      case TaskPriority.medium:
        label = 'Medium';
        textColor = AppColors.priorityMedText;
        bgColor = AppColors.priorityMedBg;
        break;
      case TaskPriority.low:
        label = 'Low';
        textColor = AppColors.priorityLowText;
        bgColor = AppColors.priorityLowBg;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final TaskStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == TaskStatus.submitted;
    final String label = isCompleted ? 'Completed' : 'Pending';
    final Color textColor = isCompleted
        ? AppColors.statusCompletedText
        : AppColors.statusPendingText;
    final Color bgColor = isCompleted
        ? AppColors.statusCompletedBg
        : AppColors.statusPendingBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
