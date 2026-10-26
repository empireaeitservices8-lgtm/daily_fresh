import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/task_success_dialog.dart';

class SubmitTaskScreen extends StatefulWidget {
  final TaskItem task;
  final AppState state;

  const SubmitTaskScreen({
    super.key,
    required this.task,
    required this.state,
  });

  @override
  State<SubmitTaskScreen> createState() => _SubmitTaskScreenState();
}

class _SubmitTaskScreenState extends State<SubmitTaskScreen> {
  late TextEditingController _skuCountController;
  late TextEditingController _discrepancyDetailsController;
  late TextEditingController _actionsTakenController;
  late TextEditingController _notesController;
  String _discrepancyValue = 'Yes';
  late List<String> _photos;
  final List<String> _attachedDocuments = [
    'Audit_Report_May15.xlsx',
    'Discrepancy_Log.docx',
  ];

  @override
  void initState() {
    super.initState();
    _skuCountController = TextEditingController(
      text: widget.task.skuCount != null ? '${widget.task.skuCount}' : '250',
    );
    _discrepancyValue = (widget.task.discrepancyFound ?? true) ? 'Yes' : 'No';
    _discrepancyDetailsController = TextEditingController(
      text: widget.task.discrepancyDetails ?? '5 items with quantity mismatch',
    );
    _actionsTakenController = TextEditingController(
      text: widget.task.actionsTaken ?? 'Corrected quantities and informed team',
    );
    _notesController = TextEditingController(
      text: 'Routine audit completed. Minor barcode alignment issues flagged in aisle 3.',
    );
    _photos = widget.task.photoUrls.isNotEmpty
        ? List.from(widget.task.photoUrls)
        : [
            'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60',
            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60',
          ];
  }

  @override
  void dispose() {
    _skuCountController.dispose();
    _discrepancyDetailsController.dispose();
    _actionsTakenController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addFileModal() {
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
                'Upload Task File (Image, Excel, Word)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryGreen),
                title: const Text('Capture Image'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _photos.add('https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=500&auto=format&fit=crop&q=60');
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_rounded, color: Color(0xFF16A34A)),
                title: const Text('Attach Excel Spreadsheet (.xlsx)'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _attachedDocuments.add('Stock_Discrepancy_Sheet_${DateTime.now().minute}.xlsx');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Excel spreadsheet attached successfully')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_rounded, color: Color(0xFF0284C7)),
                title: const Text('Attach Word Document (.docx)'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _attachedDocuments.add('Audit_Explanation_${DateTime.now().minute}.docx');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Word document attached successfully')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final sku = int.tryParse(_skuCountController.text.trim()) ?? 250;
    final isDiscrepancy = _discrepancyValue == 'Yes';

    widget.state.submitTask(
      taskId: widget.task.id,
      skuCount: sku,
      discrepancyFound: isDiscrepancy,
      discrepancyDetails: _discrepancyDetailsController.text.trim(),
      actionsTaken: _actionsTakenController.text.trim(),
      photos: _photos,
    );

    widget.task.attachedFiles = List.from(_attachedDocuments);

    // Show success dialog
    TaskSuccessDialog.show(
      context: context,
      task: widget.task,
      state: widget.state,
      submissionTime: DateTime(2024, 5, 15, 9, 45),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime(2024, 5, 15, 9, 45);
    final formattedTime = DateFormat('MMMM d, y hh:mm a').format(now);

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
          'Submit Task (Module A)',
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
            // Workflow Auto-filled Summary Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.task.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Status: Completed',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.task.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),

                  // Auto-filled Metadata Grid
                  _buildMetaRow('Branch', widget.task.branch),
                  const SizedBox(height: 6),
                  _buildMetaRow('Department', widget.task.department),
                  const SizedBox(height: 6),
                  _buildMetaRow('Submitter Name', widget.task.submitterName),
                  const SizedBox(height: 6),
                  _buildMetaRow('Submission Date', formattedTime, isHighlight: true),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Form Inputs Section
            Text(
              'Audit Details & Discrepancies',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            // SKU Count
            _buildFieldLabel('SKU Count Checked'),
            TextField(
              controller: _skuCountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. 250',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textLight),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Discrepancy Found Radio
            _buildFieldLabel('Discrepancy Found?'),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _discrepancyValue = 'Yes'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _discrepancyValue == 'Yes' ? const Color(0xFFFEE2E2) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _discrepancyValue == 'Yes' ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
                            width: _discrepancyValue == 'Yes' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: _discrepancyValue == 'Yes' ? const Color(0xFFDC2626) : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Yes (Flag Issue)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: _discrepancyValue == 'Yes' ? const Color(0xFFDC2626) : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _discrepancyValue = 'No'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _discrepancyValue == 'No' ? const Color(0xFFDCFCE7) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _discrepancyValue == 'No' ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
                            width: _discrepancyValue == 'No' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: _discrepancyValue == 'No' ? const Color(0xFF16A34A) : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'No (All Normal)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: _discrepancyValue == 'No' ? const Color(0xFF16A34A) : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Discrepancy Notes / Details (Module A Field: Short note on task, highlight challenges)
            _buildFieldLabel('Challenges / Discrepancy Notes'),
            TextField(
              controller: _discrepancyDetailsController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Add a short note on task, highlight challenges or discrepancies...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textLight),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Actions Taken
            _buildFieldLabel('Actions Taken'),
            TextField(
              controller: _actionsTakenController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Corrected quantities, adjusted planogram, or informed store team...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textLight),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // File Upload Section (Image, Excel, Word)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Uploaded Files (Image, Excel, Word)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.attach_file_rounded, size: 16),
                  label: const Text('Add File'),
                  onPressed: _addFileModal,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Image Thumbnails
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _photos.map((url) {
                  return Container(
                    width: 76,
                    height: 76,
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
            const SizedBox(height: 10),

            // Attached Documents (Excel & Word)
            ..._attachedDocuments.map((doc) {
              final isExcel = doc.endsWith('.xlsx') || doc.endsWith('.xls');
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isExcel ? const Color(0xFFF0FDF4) : const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isExcel ? const Color(0xFFBBF7D0) : const Color(0xFFBAE6FD),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isExcel ? Icons.table_chart_rounded : Icons.description_rounded,
                      color: isExcel ? const Color(0xFF16A34A) : const Color(0xFF0284C7),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 16),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: Text(
                  'Submit Task',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: isHighlight ? AppColors.primaryGreen : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
