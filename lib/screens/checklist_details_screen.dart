import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/checklist_model.dart';
import '../theme/app_theme.dart';
import 'submit_checklist_screen.dart';

class ChecklistDetailsScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback onUpdated;

  const ChecklistDetailsScreen({
    super.key,
    required this.item,
    required this.onUpdated,
  });

  @override
  State<ChecklistDetailsScreen> createState() => _ChecklistDetailsScreenState();
}

class _ChecklistDetailsScreenState extends State<ChecklistDetailsScreen> {
  late ChecklistItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;

    // Ensure default sub-items exist if empty
    if (_item.subItems.isEmpty) {
      _item.subItems.addAll([
        ChecklistSubItem(id: 'sub-1', title: 'All billing counters closed', isCompleted: true),
        ChecklistSubItem(id: 'sub-2', title: 'Cash reconciliation completed'),
        ChecklistSubItem(id: 'sub-3', title: 'All lights switched off'),
        ChecklistSubItem(id: 'sub-4', title: 'All equipment switched off'),
        ChecklistSubItem(id: 'sub-5', title: 'Security doors locked'),
        ChecklistSubItem(id: 'sub-6', title: 'Floor cleaned & dry'),
        ChecklistSubItem(id: 'sub-7', title: 'Waste bins emptied'),
        ChecklistSubItem(id: 'sub-8', title: 'Closing announcement done'),
      ]);
    }
  }

  void _toggleSubItem(ChecklistSubItem subItem) {
    setState(() {
      subItem.isCompleted = !subItem.isCompleted;
      if (subItem.isCompleted) {
        subItem.answer = ChecklistAnswer.yes;
      }
      // If all subitems completed, update status
      if (_item.completedSubItemCount == _item.totalSubItemCount) {
        _item.status = ChecklistStatus.completed;
      } else if (_item.status == ChecklistStatus.completed) {
        _item.status = ChecklistStatus.pending;
      }
    });
    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _item.completedSubItemCount;
    final totalCount = _item.totalSubItemCount;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checklist Details',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Overview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _item.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _item.section,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Due: ${_item.dueTime}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _item.statusBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _item.statusLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _item.statusTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _item.description ??
                        'Ensure all department checkpoints and store safety guidelines are verified.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '$completedCount of $totalCount completed',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Header: Checklist Items
            Text(
              'Checklist Items',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Sub-items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _item.subItems.length,
              itemBuilder: (context, index) {
                final sub = _item.subItems[index];
                final isDone = sub.isCompleted || sub.answer == ChecklistAnswer.yes;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDone ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _toggleSubItem(sub),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${sub.title}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                color: isDone ? AppColors.textLight : AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isDone ? const Color(0xFF16A34A) : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isDone ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1),
                                width: 1.8,
                              ),
                            ),
                            child: isDone
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Bottom Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assignment_turned_in_rounded, size: 20),
                label: Text(
                  _item.status == ChecklistStatus.completed
                      ? 'Re-evaluate / Edit Submission'
                      : 'Submit Checklist',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SubmitChecklistScreen(
                        item: _item,
                        onSubmitted: () {
                          setState(() {});
                          widget.onUpdated();
                        },
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
