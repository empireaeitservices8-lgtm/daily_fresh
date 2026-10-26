import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/register_model.dart';
import '../theme/app_theme.dart';

class DisplayManagementScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const DisplayManagementScreen({super.key, this.onBack});

  @override
  State<DisplayManagementScreen> createState() => _DisplayManagementScreenState();
}

class _DisplayManagementScreenState extends State<DisplayManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _salesDepartments = [
    'Fresh Produce',
    'Dairy & Chilled Foods',
    'Meat & Butchery',
    'Fresh Bakery',
    'Dry Grocery & Beverages',
    'Household & Personal Care',
  ];

  late String _selectedDepartment;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _photos = [
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60',
  ];

  final List<String> _attachedDocs = ['FEFO_Arrangement_Aisle2.xlsx'];

  final List<DisplayManagementUpdate> _history = [
    DisplayManagementUpdate(
      id: 'disp-1',
      department: 'Fresh Produce',
      submissionDate: DateTime(2024, 5, 15, 9, 30),
      notes: 'Morning fresh produce misting and front gondola display done.',
      fileUrls: ['https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60'],
      fileNames: ['Produce_Morning_Gondola.jpg'],
    ),
    DisplayManagementUpdate(
      id: 'disp-2',
      department: 'Dairy & Chilled Foods',
      submissionDate: DateTime(2024, 5, 15, 9, 50),
      notes: 'Milk bottles fronted and older stock aligned to FEFO rule.',
      fileUrls: ['https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60'],
      fileNames: ['Dairy_FEFO_Check.jpg', 'FEFO_Chiller_Report.xlsx'],
    ),
  ];

  final List<DisplayManagementUpdate> _arearsList = [
    DisplayManagementUpdate(
      id: 'disp-ar-1',
      department: 'Fresh Bakery',
      submissionDate: DateTime(2024, 5, 15, 10, 30),
      isArears: true,
      notes: 'Missed 10:00 AM cutoff due to morning oven restocking rush.',
    ),
    DisplayManagementUpdate(
      id: 'disp-ar-2',
      department: 'Dry Grocery & Beverages',
      submissionDate: DateTime(2024, 5, 15, 11, 0),
      isArears: true,
      notes: 'Gondola planogram setup delayed.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDepartment = _salesDepartments.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final newSubmission = DisplayManagementUpdate(
      id: 'disp-${DateTime.now().millisecondsSinceEpoch}',
      department: _selectedDepartment,
      submissionDate: DateTime(2024, 5, 15, 9, 45),
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : 'FEFO display photo uploaded before 10:00 AM deadline.',
      fileUrls: List.from(_photos),
      fileNames: List.from(_attachedDocs),
    );

    setState(() {
      _history.insert(0, newSubmission);
      _notesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Display & FEFO photos submitted successfully (Before 10:00 AM)'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void _requestAdminApproval(DisplayManagementUpdate item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Request Admin Approval',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This display update for ${item.department} missed the 10:00 AM deadline and is in Arears. Would you like to send an approval request to Store Admin to unlock submission?',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () {
              setState(() {
                item.adminApprovalRequested = true;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Admin approval requested. Awaiting Store Manager sign-off.'),
                  backgroundColor: Color(0xFF0284C7),
                ),
              );
            },
            child: const Text('Send Request', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final submissionDateStr = DateFormat('MMMM d, y hh:mm a').format(DateTime(2024, 5, 15, 9, 45));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Daily Display Management (Module 8)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: 'Daily Submission (${_history.length})'),
            Tab(text: 'Daily Updates Arears (${_arearsList.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -----------------------------------------------------------------
          // Tab 1: Daily Submission
          // -----------------------------------------------------------------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 10:00 AM Rule Alert Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.alarm_on_rounded, color: Color(0xFFB45309), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Strict 10:00 AM Cutoff Rule',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Must take photos of your displays and FEFO arrangements and upload them by 10:00 AM every day. After 10:00 AM, the task moves to Arears and requires Admin approval.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: const Color(0xFF78350F),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
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
                      Text(
                        'Upload Display & FEFO Photos',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Submission Date (Non-editable timestamp)
                      _buildFieldLabel('Submission Date (Non-editable)'),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          submissionDateStr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sales Department Dropdown
                      _buildFieldLabel('Department (Sales Departments)'),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedDepartment,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _salesDepartments
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                    d,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedDepartment = v);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Submitter Name (Auto-filled)
                      _buildFieldLabel('Submitter Name'),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          'Juan Dela Cruz (Store Manager)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Notes / Observation
                      _buildFieldLabel('Arrangement & FEFO Notes'),
                      TextField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'e.g. End-caps aligned, expiry dates rotated properly...',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Multiple File Upload Options (Image, Excel, Word)
                      _buildFieldLabel('Display Photos & Files (Image, Excel, Word)'),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                            label: const Text('Add Photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {
                              setState(() {
                                _photos.add('https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=500&auto=format&fit=crop&q=60');
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.table_chart_rounded, size: 16),
                            label: const Text('Attach Sheet'),
                            onPressed: () {
                              setState(() {
                                _attachedDocs.add('Planogram_Layout_${DateTime.now().minute}.xlsx');
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Preview Photos
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _photos.map((url) {
                            return Container(
                              width: 72,
                              height: 72,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Preview Files
                      ..._attachedDocs.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file_rounded, size: 16, color: AppColors.primaryGreen),
                              const SizedBox(width: 6),
                              Text(f, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _submit,
                          child: Text(
                            'Submit Display Update',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Submissions Log
                Text(
                  'Today\'s Submissions Log',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),

                ..._history.map((h) => _buildHistoryCard(h)),
              ],
            ),
          ),

          // -----------------------------------------------------------------
          // Tab 2: Daily Updates Arears
          // -----------------------------------------------------------------
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _arearsList.length,
            itemBuilder: (context, index) {
              final ar = _arearsList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECACA)),
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
                        Text(
                          ar.department,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF991B1B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Arears (Missed 10 AM)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ar.notes ?? 'No display photos recorded before 10:00 AM cutoff.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deadline: 10:00 AM',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(
                            ar.adminApprovalRequested ? Icons.hourglass_top_rounded : Icons.lock_open_rounded,
                            size: 14,
                          ),
                          label: Text(
                            ar.adminApprovalRequested ? 'Approval Pending' : 'Request Admin Approval',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ar.adminApprovalRequested ? const Color(0xFF94A3B8) : const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onPressed: ar.adminApprovalRequested ? null : () => _requestAdminApproval(ar),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildHistoryCard(DisplayManagementUpdate h) {
    final timeStr = DateFormat('hh:mm a').format(h.submissionDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h.department,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  h.notes ?? '',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
