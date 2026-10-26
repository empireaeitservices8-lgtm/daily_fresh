import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';
import '../widgets/notification_button.dart';
import 'arears_report_screen.dart';
import 'gm_task_creation_screen.dart';
import 'submit_task_screen.dart';
import 'submitted_tasks_screen.dart';

class SmHubScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;

  const SmHubScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
  });

  @override
  State<SmHubScreen> createState() => _SmHubScreenState();
}

class _SmHubScreenState extends State<SmHubScreen> with SingleTickerProviderStateMixin {
  late TabController _moduleTabController;

  // Predefined EOD Reports list matching Spreadsheet Module B
  final List<Map<String, dynamic>> _eodReports = [
    {
      'id': 'eod-1',
      'name': 'Daily Inventory Operations Report',
      'dept': 'Inventory',
      'status': 'Pending',
      'assignee': 'Suresh Kumar (Inventory Lead)',
      'due': '05:00 PM',
      'icon': Icons.inventory_2_outlined,
      'isArrears': false,
    },
    {
      'id': 'eod-2',
      'name': 'Daily Warehouse and Packing Operations Report',
      'dept': 'Warehouse',
      'status': 'Pending',
      'assignee': 'Anand Verma (Logistics)',
      'due': '06:00 PM',
      'icon': Icons.local_shipping_outlined,
      'isArrears': false,
    },
    {
      'id': 'eod-3',
      'name': 'Daily Sales Supervisors Report',
      'dept': 'Sales',
      'status': 'Completed',
      'assignee': 'Priya Nair (Sales Sup)',
      'due': '04:00 PM',
      'icon': Icons.trending_up_rounded,
      'isArrears': false,
    },
    {
      'id': 'eod-4',
      'name': 'Daily CRM Report',
      'dept': 'CRM',
      'status': 'Completed',
      'assignee': 'Rahul Roy (CRM Agent)',
      'due': '03:30 PM',
      'icon': Icons.support_agent_outlined,
      'isArrears': false,
    },
    {
      'id': 'eod-5',
      'name': 'Daily HR & Shift Attendance Report',
      'dept': 'Human Resources',
      'status': 'Arrears',
      'assignee': 'Deepa Mathew (HR Exec)',
      'due': 'Yesterday 01:00 PM',
      'icon': Icons.badge_outlined,
      'isArrears': true,
    },
    {
      'id': 'eod-6',
      'name': 'Daily Store Operations & Cash Audit',
      'dept': 'Cash & Registers',
      'status': 'Arrears',
      'assignee': 'Vijay Sharma (Cashier Lead)',
      'due': 'Yesterday 01:00 PM',
      'icon': Icons.point_of_sale_outlined,
      'isArrears': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _moduleTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _moduleTabController.dispose();
    super.dispose();
  }

  void _showTaskCreationModal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2563EB),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Store Manager - Create Task',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          body: GmTaskCreationScreen(
            state: widget.state,
            onOpenDrawer: widget.onOpenDrawer,
          ),
        ),
      ),
    );
  }

  void _approveArrears(String reportId, String reportName) {
    widget.state.approveArrearsReport(reportId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF16A34A),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'SM Approved "$reportName" for submission.',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.state.currentUser;
    final pendingTasks = widget.state.pendingTasks;
    final completedTasks = widget.state.submittedTasks;
    final completionPct = widget.state.progressPercentage;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 1. Header Bar: DayFresh Logo + SM Badge & Profile
                  _buildHeaderBar(user),

                  // 2. SM Branch Card & KPI Highlights
                  _buildStoreKpiCard(user, pendingTasks.length, completedTasks.length, completionPct),

                  // 3. 1:00 PM EOD Rule Notice Banner
                  _buildArrearsNoticeBanner(),

                  const SizedBox(height: 8),

                  // 4. Module Navigation Tabs (Module A, Module B, Audit & Review)
                  _buildTabBar(),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _moduleTabController,
            children: [
              // Tab 1: Module A - Tasks Module (Random Pending, Completed, Task Creation)
              _buildModuleATasksView(pendingTasks, completedTasks),

              // Tab 2: Module B - Daily Checklist Module 1 - 7 (Pending, Completed, Arrears)
              _buildModuleBDailyReportsView(),

              // Tab 3: Section B - Audit & Review Dashboard
              _buildAuditReviewDashboardView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: Text(
          'Create Task',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        onPressed: _showTaskCreationModal,
      ),
    );
  }

  // 1. Header Bar
  Widget _buildHeaderBar(dynamic user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textDark, size: 26),
            onPressed: widget.onOpenDrawer,
            tooltip: 'Open Menu',
          ),
          const SizedBox(width: 4),
          const DayFreshLogo(scale: 0.9, isDarkBackground: false),
          const Spacer(),

          // Store Manager Role Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_rounded, size: 14, color: Color(0xFF2563EB)),
                const SizedBox(width: 4),
                Text(
                  'SM Interface',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          NotificationBellButton(
            count: widget.state.unreadNotifications,
            onTap: () {
              widget.state.clearNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications marked as read')),
              );
            },
          ),
        ],
      ),
    );
  }

  // 2. SM Branch Card & KPI Highlights
  Widget _buildStoreKpiCard(dynamic user, int pendingCount, int completedCount, int progressPct) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  user.initials,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Store Manager • ${user.storeBranch}',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 26),
                tooltip: 'Create New Task',
                onPressed: _showTaskCreationModal,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCol('Pending Tasks', '$pendingCount', Icons.pending_actions_rounded),
                Container(width: 1, height: 26, color: Colors.white.withValues(alpha: 0.2)),
                _buildMetricCol('Completed', '$completedCount', Icons.check_circle_rounded),
                Container(width: 1, height: 26, color: Colors.white.withValues(alpha: 0.2)),
                _buildMetricCol('Compliance', '$progressPct%', Icons.verified_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 3. 1:00 PM Arrears Cutoff Rule Banner
  Widget _buildArrearsNoticeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled_rounded, color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Daily EOD Cutoff: Reports expire at 1:00 PM next day. Unsubmitted move to Arrears & need SM approval.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: const Color(0xFF991B1B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Tab Bar (Module A, Module B, Audit & Review)
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TabBar(
        controller: _moduleTabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        labelColor: const Color(0xFF0F172A),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        tabs: const [
          Tab(
            height: 36,
            child: Text(
              'Tasks (A)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            height: 36,
            child: Text(
              'EOD Reports (B)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            height: 36,
            child: Text(
              'Audit & Review',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: MODULE A - TASKS MODULE
  Widget _buildModuleATasksView(List<TaskItem> pendingTasks, List<TaskItem> completedTasks) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Action Card to Create Task
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_task_rounded, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Creation (Module A)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Assign tasks to dept supervisors or floor associates',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _showTaskCreationModal,
                child: const Text('New Task'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Section: Random Tasks Pending (View & Submit Pending Tasks)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Random Tasks Pending (${pendingTasks.length})',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: const Color(0xFFB45309),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Spreadsheet Sec A',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFB45309)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (pendingTasks.isEmpty)
          _buildEmptyCard('No pending tasks for this store')
        else
          ...pendingTasks.map((t) => _buildSmTaskPendingCard(t)),

        const SizedBox(height: 18),

        // Section: Task Completed (View Submitted Tasks - Read Only)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Task Completed (${completedTasks.length})',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: const Color(0xFF15803D),
              ),
            ),
            Text(
              'View Submitted Tasks (Not Editable)',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (completedTasks.isEmpty)
          _buildEmptyCard('No submitted tasks yet')
        else
          ...completedTasks.take(4).map((t) => _buildSmTaskCompletedCard(t)),
      ],
    );
  }

  Widget _buildSmTaskPendingCard(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.assignment_late_outlined, size: 16, color: Color(0xFFB45309)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                task.time,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              task.description,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textDark),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Branch: #104 City Center',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.rate_review_outlined, size: 14),
                label: const Text('Review / Submit', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubmitTaskScreen(task: task, state: widget.state),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmTaskCompletedCard(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Submitted ${task.submittedAt != null ? DateFormat('hh:mm a').format(task.submittedAt!) : task.time}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF64748B)),
            tooltip: 'View submitted record (Not editable)',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SubmittedTasksScreen(
                    state: widget.state,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 2: MODULE B - DAILY CHECKLIST MODULE 1 - 7 (EOD REPORTS)
  Widget _buildModuleBDailyReportsView() {
    final pendingEOD = _eodReports.where((r) => r['status'] == 'Pending').toList();
    final completedEOD = _eodReports.where((r) => r['status'] == 'Completed').toList();
    final arrearsEOD = _eodReports.where((r) => r['status'] == 'Arrears').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Daily Checklist Module 1 - 7 Header Info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Checklist Module 1 - 7 (Daily Operations Related Reports)',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: const Color(0xFF92400E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Predefined daily checklists assigned to specific store departments. Submissions allow back-dated operations for compliance audits.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF78350F),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Sub-Module: Daily Reports Pending
        _buildSectionHeader(
          'Daily Reports Pending (${pendingEOD.length})',
          const Color(0xFFD97706),
          Icons.pending_actions_rounded,
        ),
        const SizedBox(height: 8),
        ...pendingEOD.map((r) => _buildEodCard(r)),

        const SizedBox(height: 16),

        // Sub-Module: Daily Reports Completed
        _buildSectionHeader(
          'Daily Reports Completed (${completedEOD.length})',
          const Color(0xFF16A34A),
          Icons.task_alt_rounded,
        ),
        const SizedBox(height: 8),
        ...completedEOD.map((r) => _buildEodCard(r)),

        const SizedBox(height: 16),

        // Sub-Module: Daily Reports Arrears
        _buildSectionHeader(
          'Daily Reports Arrears (${arrearsEOD.length})',
          const Color(0xFFDC2626),
          Icons.warning_amber_rounded,
        ),
        const SizedBox(height: 8),
        ...arrearsEOD.map((r) => _buildEodCard(r)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEodCard(Map<String, dynamic> report) {
    final status = report['status'] as String;
    final isArrears = status == 'Arrears';
    final isApproved = widget.state.isArrearsApproved(report['id']);

    Color badgeBg;
    Color badgeText;
    if (status == 'Completed') {
      badgeBg = const Color(0xFFDCFCE7);
      badgeText = const Color(0xFF15803D);
    } else if (status == 'Pending') {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFFB45309);
    } else {
      badgeBg = isApproved ? const Color(0xFFEFF6FF) : const Color(0xFFFEE2E2);
      badgeText = isApproved ? const Color(0xFF1D4ED8) : const Color(0xFFB91C1C);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isArrears
              ? (isApproved ? const Color(0xFF93C5FD) : const Color(0xFFFCA5A5))
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(report['icon'] as IconData, size: 20, color: const Color(0xFF334155)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Dept: ${report['dept']} • Assignee: ${report['assignee']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isApproved ? 'SM Approved' : status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due / Cutoff: ${report['due']}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isArrears ? const Color(0xFFDC2626) : AppColors.textMuted,
                  fontWeight: isArrears ? FontWeight.w600 : FontWeight.w400,
                ),
              ),

              if (isArrears && !isApproved)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 13),
                  label: const Text('SM Approve'),
                  onPressed: () => _approveArrears(report['id'], report['name']),
                )
              else if (status == 'Completed')
                Text(
                  'Verified by SOP',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF16A34A), fontWeight: FontWeight.w600),
                )
              else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Open SOP Form', style: TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                  onPressed: () {
                    widget.state.setNavIndex(2); // Navigate to Checklists
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 3: SECTION B - AUDIT & REVIEW DASHBOARD
  Widget _buildAuditReviewDashboardView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Audit Overview Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Audit & Review Dashboard',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Score: 94.2%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Branch #104 City Center • Comprehensive Department SOP Audit',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.942,
                  minHeight: 10,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Department SOP Compliance Rates',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),

        _buildDeptAuditBar('Fresh Produce & Fruit Displays', 0.96, '96%', const Color(0xFF16A34A)),
        _buildDeptAuditBar('Dairy, Frozen & Temperature Logs', 0.91, '91%', const Color(0xFF2563EB)),
        _buildDeptAuditBar('Bakery & Fresh Food Sanitation', 0.95, '95%', const Color(0xFF16A34A)),
        _buildDeptAuditBar('Warehouse & Inventory Shrinkage', 0.88, '88%', const Color(0xFFD97706)),
        _buildDeptAuditBar('POS Registers & Cash Balancing', 0.98, '98%', const Color(0xFF16A34A)),
        _buildDeptAuditBar('Customer Service & Hygiene Logs', 0.93, '93%', const Color(0xFF2563EB)),

        const SizedBox(height: 18),

        // Quick Link to Arears Full Inspection
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArearsReportScreen(
                  items: const [],
                  onNavigateToTab: (index) {
                    widget.state.setNavIndex(index);
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics_outlined, color: Color(0xFF1D4ED8)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed Arrears & Audit Report',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      Text(
                        'Review historical non-compliance logs & admin requests',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF1D4ED8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeptAuditBar(String dept, double progress, String pct, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dept,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                pct,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String msg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Text(
          msg,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
