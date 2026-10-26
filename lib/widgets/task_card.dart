import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'task_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final bool showDuePrefix;
  final bool showSubmittedPrefix;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.showDuePrefix = false,
    this.showSubmittedPrefix = false,
  });

  @override
  Widget build(BuildContext context) {
    String timeText = task.time;
    if (showDuePrefix) {
      timeText = 'Due: ${task.time}';
    } else if (showSubmittedPrefix || task.status == TaskStatus.submitted) {
      timeText = 'Submitted: ${task.time}';
    }

    final targetDateStr = DateFormat('MMM d').format(task.targetExecutionDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: AppColors.primaryGreen.withValues(alpha: 0.06),
          highlightColor: AppColors.primaryGreen.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${task.department} • Target: $targetDateStr ($timeText)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          PriorityBadge(priority: task.priority),
                          if (task.attachedFiles.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.textMuted),
                            Text(
                              '${task.attachedFiles.length} files',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: task.status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
