import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/notification_button.dart';
import '../widgets/task_card.dart';
import 'submit_task_screen.dart';
import 'submitted_tasks_screen.dart';

class AllTasksScreen extends StatefulWidget {
  final AppState state;
  final int initialTabIndex;
  final bool showBottomNav;

  const AllTasksScreen({
    super.key,
    required this.state,
    this.initialTabIndex = 0,
    this.showBottomNav = false,
  });

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  late int _activeTabIndex;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeTabIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final int pendingCount = widget.state.pendingTasksCount;
        final int submittedCount = widget.state.submittedTasksCount;
        final query = _searchController.text.toLowerCase().trim();

        List<TaskItem> displayedTasks;
        if (_activeTabIndex == 1) {
          displayedTasks = widget.state.pendingTasks;
        } else if (_activeTabIndex == 2) {
          displayedTasks = widget.state.submittedTasks;
        } else {
          // Task List (all tasks)
          displayedTasks = widget.state.allTasks;
        }

        if (query.isNotEmpty) {
          displayedTasks = displayedTasks
              .where((t) => t.title.toLowerCase().contains(query))
              .toList();
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            title: Text(
              'All Tasks',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
            actions: [
              NotificationBellButton(
                count: widget.state.unreadNotifications,
                onTap: () {
                  widget.state.clearNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications marked as read')),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          bottomNavigationBar: widget.showBottomNav
              ? DayFreshBottomNav(
                  currentIndex: widget.state.currentNavIndex,
                  onTabSelected: (index) {
                    widget.state.setNavIndex(index);
                  },
                )
              : null,
          body: Column(
            children: [
              // Tabs Header: Task List | Pending (5) | Submitted (7)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildTabItem(0, 'Task List'),
                        _buildTabItem(1, 'Pending ($pendingCount)'),
                        _buildTabItem(2, 'Submitted ($submittedCount)'),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  ],
                ),
              ),

              // Search Bar & Filter Button
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
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
                            hintText: 'Search tasks...',
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
                          _showFilterBottomSheet(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Task Cards List
              Expanded(
                child: displayedTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks found matching query',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        itemCount: displayedTasks.length,
                        itemBuilder: (context, index) {
                          final task = displayedTasks[index];
                          return TaskCard(
                            task: task,
                            showDuePrefix: task.status == TaskStatus.pending,
                            showSubmittedPrefix: task.status == TaskStatus.submitted,
                            onTap: () {
                              if (task.status == TaskStatus.pending) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubmitTaskScreen(
                                      task: task,
                                      state: widget.state,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubmittedTasksScreen(
                                      state: widget.state,
                                    ),
                                  ),
                                );
                              }
                            },
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Tasks by Priority',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: true,
                    onSelected: (_) => Navigator.pop(ctx),
                  ),
                  ChoiceChip(
                    label: const Text('High Priority'),
                    selected: false,
                    onSelected: (_) => Navigator.pop(ctx),
                  ),
                  ChoiceChip(
                    label: const Text('Medium Priority'),
                    selected: false,
                    onSelected: (_) => Navigator.pop(ctx),
                  ),
                  ChoiceChip(
                    label: const Text('Low Priority'),
                    selected: false,
                    onSelected: (_) => Navigator.pop(ctx),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
