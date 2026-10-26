import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/checklist_model.dart';
import '../theme/app_theme.dart';

class ArearsReportScreen extends StatelessWidget {
  final List<ChecklistItem> items;
  final Function(int)? onNavigateToTab;

  const ArearsReportScreen({
    super.key,
    required this.items,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final arearsItems =
        items.where((i) => i.status == ChecklistStatus.arears).toList();
    final arearsCount = arearsItems.length;

    // Group by section
    final Map<String, int> sectionMap = {};
    for (final it in arearsItems) {
      sectionMap[it.section] = (sectionMap[it.section] ?? 0) + 1;
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Arears Report',
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
            // Total Arears Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Arears',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF991B1B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$arearsCount',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7F1D1D),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.insert_chart_rounded,
                      color: Color(0xFFEF4444),
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Breakup by Section
            Text(
              'Breakup by Section',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSectionRow('Bakery', sectionMap['Bakery'] ?? 1),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildSectionRow('Visual', sectionMap['Visual'] ?? 1),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildSectionRow('Inventory', sectionMap['Inventory'] ?? 1),
                  if (sectionMap.keys.any(
                    (k) => !['Bakery', 'Visual', 'Inventory'].contains(k),
                  ))
                    ...sectionMap.entries
                        .where(
                          (e) => !['Bakery', 'Visual', 'Inventory'].contains(
                            e.key,
                          ),
                        )
                        .map(
                          (e) => Column(
                            children: [
                              const Divider(
                                height: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                              _buildSectionRow(e.key, e.value),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Arears Summary
            Text(
              'Arears Summary',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Overdue Checklists', '$arearsCount'),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildSummaryRow('Longest Overdue', '2h 30m'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Export Report Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.file_download_outlined,
                  size: 20,
                  color: Color(0xFF16A34A),
                ),
                label: Text(
                  'Export Report',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF16A34A),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F5E9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFC8E6C9)),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Arears report exported successfully (PDF)'),
                      backgroundColor: Color(0xFF16A34A),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionRow(String section, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            section,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Text(
            '$count',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
