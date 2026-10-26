import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/checklist_model.dart';
import '../theme/app_theme.dart';
import 'checklist_success_screen.dart';

class SubmitChecklistScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback onSubmitted;

  const SubmitChecklistScreen({
    super.key,
    required this.item,
    required this.onSubmitted,
  });

  @override
  State<SubmitChecklistScreen> createState() => _SubmitChecklistScreenState();
}

class _SubmitChecklistScreenState extends State<SubmitChecklistScreen> {
  late ChecklistItem _item;
  DateTime _operationDate = DateTime(2024, 5, 15);
  final List<String> _photos = [
    'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=500&auto=format&fit=crop&q=60',
  ];

  @override
  void initState() {
    super.initState();
    _item = widget.item;

    if (_item.subItems.isEmpty) {
      _item.subItems.addAll([
        ChecklistSubItem(
          id: 'sub-1',
          title: 'All billing counters closed',
          answer: ChecklistAnswer.yes,
          isCompleted: true,
        ),
        ChecklistSubItem(id: 'sub-2', title: 'Cash reconciliation completed'),
        ChecklistSubItem(
          id: 'sub-3',
          title: 'All lights switched off',
          answer: ChecklistAnswer.yes,
          isCompleted: true,
        ),
        ChecklistSubItem(id: 'sub-4', title: 'All equipment switched off'),
        ChecklistSubItem(id: 'sub-5', title: 'Security doors locked'),
        ChecklistSubItem(id: 'sub-6', title: 'Floor cleaned & dry'),
        ChecklistSubItem(id: 'sub-7', title: 'Waste bins emptied'),
        ChecklistSubItem(id: 'sub-8', title: 'Closing announcement done'),
      ]);
    }
  }

  void _pickOperationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _operationDate,
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
      setState(() {
        _operationDate = picked;
      });
    }
  }

  void _submit() {
    setState(() {
      for (final s in _item.subItems) {
        s.answer ??= ChecklistAnswer.yes;
        s.isCompleted = true;
      }
      _item.status = ChecklistStatus.completed;
      _item.submittedAt = DateTime(2024, 5, 15, 21, 28);
      _item.photos = List.from(_photos);
    });

    widget.onSubmitted();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => ChecklistSuccessScreen(
          item: _item,
          onViewSubmitted: () {
            Navigator.pop(ctx);
          },
          onClose: () {
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _addPhotoMock() {
    setState(() {
      _photos.add(
        'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9?w=500&auto=format&fit=crop&q=60',
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo attached successfully'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final submissionDateStr = DateFormat('MMMM d, y hh:mm a').format(DateTime(2024, 5, 15, 21, 28));
    final opDateStr = DateFormat('MMMM d, y').format(_operationDate);

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
          'Submit Daily Checklist (Module B)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
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
            // Module B Auto-filled Metadata Card
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
                    _item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Department: ${_item.section} • Due: ${_item.dueTime}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),

                  _buildMetaRow('Submitter Name', 'Juan Dela Cruz (Login ID)'),
                  const SizedBox(height: 6),
                  _buildMetaRow('Submission Date', submissionDateStr, isSystem: true),
                  const SizedBox(height: 10),

                  // Operation Date Picker (Allows back-dated operation per Module B)
                  InkWell(
                    onTap: _pickOperationDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Operation Date (Allows Back-dating)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                opDateStr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.edit_calendar_rounded, size: 20, color: AppColors.primaryGreen),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // SOP Format Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Predefined SOP Checkpoints',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'Yes / No / N/A Format',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Sub-item Questionnaire with Yes, No, N/A options
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _item.subItems.length,
              itemBuilder: (context, index) {
                final sub = _item.subItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Text(
                        '${index + 1}. ${sub.title}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildRadioOption(
                            label: 'Yes',
                            value: ChecklistAnswer.yes,
                            groupValue: sub.answer,
                            activeColor: const Color(0xFF16A34A),
                            onChanged: (val) {
                              setState(() {
                                sub.answer = val;
                                sub.isCompleted = true;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildRadioOption(
                            label: 'No',
                            value: ChecklistAnswer.no,
                            groupValue: sub.answer,
                            activeColor: const Color(0xFFEF4444),
                            onChanged: (val) {
                              setState(() {
                                sub.answer = val;
                                sub.isCompleted = true;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildRadioOption(
                            label: 'N/A',
                            value: ChecklistAnswer.na,
                            groupValue: sub.answer,
                            activeColor: const Color(0xFF64748B),
                            onChanged: (val) {
                              setState(() {
                                sub.answer = val;
                                sub.isCompleted = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Add Photos Section
            Text(
              'Add Photos (Optional)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._photos.map((url) {
                    return Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                  InkWell(
                    onTap: _addPhotoMock,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.textMuted,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _submit,
                child: Text(
                  'Submit Daily Report',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.5,
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

  Widget _buildMetaRow(String label, String value, {bool isSystem = false}) {
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
            fontWeight: isSystem ? FontWeight.w700 : FontWeight.w600,
            color: isSystem ? AppColors.primaryGreen : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required ChecklistAnswer value,
    required ChecklistAnswer? groupValue,
    required Color activeColor,
    required ValueChanged<ChecklistAnswer> onChanged,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.textDark : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
