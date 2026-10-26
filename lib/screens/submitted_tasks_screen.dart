import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';

class SubmittedTasksScreen extends StatefulWidget {
  final AppState state;

  const SubmittedTasksScreen({super.key, required this.state});

  @override
  State<SubmittedTasksScreen> createState() => _SubmittedTasksScreenState();
}

class _SubmittedTasksScreenState extends State<SubmittedTasksScreen> {
  int _activeTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showTaskDetailSheet(TaskItem task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusCompletedBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.statusCompletedText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Submitted: ${task.time} • May 15, 2024',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                ),
              ),
              const Divider(height: 28),
              _buildDetailRow('Total SKU Count', '${task.skuCount ?? 250} items'),
              _buildDetailRow(
                'Discrepancy Found',
                (task.discrepancyFound ?? false) ? 'Yes' : 'No',
                valueColor: (task.discrepancyFound ?? false) ? Colors.red : AppColors.textDark,
              ),
              if (task.discrepancyDetails != null && task.discrepancyDetails!.isNotEmpty)
                _buildDetailRow('Discrepancy Details', task.discrepancyDetails!),
              if (task.actionsTaken != null && task.actionsTaken!.isNotEmpty)
                _buildDetailRow('Actions Taken', task.actionsTaken!),
              const SizedBox(height: 12),
              if (task.photoUrls.isNotEmpty) ...[
                Text(
                  'Attached Audit Photos',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.photoUrls.length,
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(task.photoUrls[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final query = _searchController.text.toLowerCase().trim();
        List<TaskItem> submittedList = widget.state.submittedTasks;

        if (query.isNotEmpty) {
          submittedList = submittedList
              .where((t) => t.title.toLowerCase().contains(query))
              .toList();
        }

        final int allCount = widget.state.submittedTasksCount;
        final int todayCount = allCount;
        final int thisWeekCount = 12;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Submitted Tasks',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              // Filter Tabs Header: All (7) | Today (7) | This Week (12)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildTabItem(0, 'All ($allCount)'),
                        _buildTabItem(1, 'Today ($todayCount)'),
                        _buildTabItem(2, 'This Week ($thisWeekCount)'),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  ],
                ),
              ),

              // Search Bar & Filter Button
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search submitted tasks...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, color: AppColors.textDark, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Filter options: All Departments')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Submitted Task Cards List
              Expanded(
                child: submittedList.isEmpty
                    ? Center(
                        child: Text(
                          'No submitted tasks found',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        itemCount: submittedList.length,
                        itemBuilder: (context, index) {
                          final task = submittedList[index];
                          return TaskCard(
                            task: task,
                            showSubmittedPrefix: true,
                            onTap: () => _showTaskDetailSheet(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTabIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF2563EB) : AppColors.textDark,
                ),
              ),
            ),
            Container(
              height: 2.5,
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
