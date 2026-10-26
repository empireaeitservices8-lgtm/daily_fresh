import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';
import '../widgets/notification_button.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import 'display_management_screen.dart';
import 'registers_screen.dart';
import 'submit_task_screen.dart';
import 'submitted_tasks_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;
  final Function(int) onNavigateTab;

  const DashboardScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
    required this.onNavigateTab,
  });

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      state.setSelectedDate(picked);
    }
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        state.clearNotifications();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Mark all as read'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.priorityHighBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.assignment_late_rounded,
                        color: AppColors.priorityHighText, size: 22),
                  ),
                  title: Text(
                    'High Priority: Stock Audit Due',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Scheduled for 10:00 AM • Aisle 4 & 5 Verification',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  trailing: const Text(
                    '10m ago',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(state.selectedDate);
    final pendingTasks = state.pendingTasks;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          onPressed: onOpenDrawer,
        ),
        centerTitle: true,
        title: const DayFreshLogo(scale: 1.05),
        actions: [
          NotificationBellButton(
            count: state.unreadNotifications,
            onTap: () => _showNotificationSheet(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Date Section
            Text(
              'Good morning, ${state.currentUser.name.trim().split(RegExp(r'\s+')).first}!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.textDark,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Summary Stats 4 Cards Row
            Row(
              children: [
                StatCard(
                  label: 'Total',
                  trailingIcon: const Icon(
                    Icons.sync_alt_rounded,
                    size: 13,
                    color: AppColors.textDark,
                  ),
                  value: '${state.totalTasksCount}',
                  valueColor: AppColors.statTotal,
                  onTap: () => onNavigateTab(1),
                ),
                const SizedBox(width: 8),
                StatCard(
                  label: 'Pending',
                  value: '${state.pendingTasksCount}',
                  valueColor: AppColors.statPending,
                  onTap: () => onNavigateTab(1),
                ),
                const SizedBox(width: 8),
                StatCard(
                  label: 'Submitted',
                  value: '${state.submittedTasksCount}',
                  valueColor: AppColors.statSubmitted,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubmittedTasksScreen(
                          state: state,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                StatCard(
                  label: 'Progress',
                  value: '${state.progressPercentage}%',
                  valueColor: AppColors.statProgress,
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Operations Workflow Modules Grid
            Text(
              'Operations Workflow Modules',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildWorkflowModuleTile(
                    context: context,
                    code: 'Module A',
                    title: 'Tasks Module',
                    subtitle: 'Random & Scheduled',
                    icon: Icons.assignment_outlined,
                    accentColor: const Color(0xFF0C5D37),
                    onTap: () => onNavigateTab(1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildWorkflowModuleTile(
                    context: context,
                    code: 'Module B',
                    title: 'Daily Checklist',
                    subtitle: '1-7 Department EOD',
                    icon: Icons.checklist_rtl_rounded,
                    accentColor: const Color(0xFFD97706),
                    onTap: () => onNavigateTab(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildWorkflowModuleTile(
                    context: context,
                    code: 'Module 8',
                    title: 'Display Updates',
                    subtitle: '10:00 AM FEFO Cutoff',
                    icon: Icons.storefront_rounded,
                    accentColor: const Color(0xFF0284C7),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const DisplayManagementScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildWorkflowModuleTile(
                    context: context,
                    code: 'Module 9',
                    title: 'Sections Registers',
                    subtitle: '9 Operational Types',
                    icon: Icons.fact_check_rounded,
                    accentColor: const Color(0xFF7C3AED),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const RegistersScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // "Pending Tasks" and "View All ->" Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pending Tasks',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                InkWell(
                  onTap: () => onNavigateTab(1),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.textDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Pending Tasks List
            if (pendingTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.statSubmitted, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'All Tasks Completed!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Great job! There are no pending tasks right now.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingTasks.length,
                itemBuilder: (context, index) {
                  final task = pendingTasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubmitTaskScreen(
                            task: task,
                            state: state,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowModuleTile({
    required BuildContext context,
    required String code,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accentColor, size: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      code,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
