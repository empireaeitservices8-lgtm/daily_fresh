import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/register_model.dart';
import '../theme/app_theme.dart';

class RegistersScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const RegistersScreen({super.key, this.onBack});

  @override
  State<RegistersScreen> createState() => _RegistersScreenState();
}

class _RegistersScreenState extends State<RegistersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _operationsDepartments = [
    'Inventory & Warehouse',
    'Sales and Operations',
    'Customer Relations (CRM)',
    'Quality & Food Safety',
    'Bakery Production',
    'Meat & Butchery Ops',
  ];

  late String _selectedDepartment;
  final Set<String> _selectedRegisterIds = {'wastage', 'fefo'};
  final TextEditingController _notesController = TextEditingController();

  final List<String> _attachedFiles = [
    'Daily_Wastage_Log_15May.xlsx',
    'Chilled_FEFO_Tracker.docx',
  ];

  final List<RegisterSubmission> _submissions = [
    RegisterSubmission(
      id: 'reg-1',
      submissionDate: DateTime(2024, 5, 15, 9, 15),
      department: 'Sales and Operations',
      selectedRegisterIds: ['wastage', 'fefo'],
      notes: 'Recorded 4 damaged fruit packs in wastage and rotated dairy milk.',
      fileNames: ['Daily_Wastage_Log_15May.xlsx', 'Chilled_FEFO_Tracker.docx'],
    ),
    RegisterSubmission(
      id: 'reg-2',
      submissionDate: DateTime(2024, 5, 15, 8, 30),
      department: 'Inventory & Warehouse',
      selectedRegisterIds: ['inward', 'prod_pack'],
      notes: 'Morning supplier shipment received: 45 crates verified against PO.',
      fileNames: ['Inward_DC_Truck4.pdf', 'Packing_Slip.xlsx'],
    ),
    RegisterSubmission(
      id: 'reg-3',
      submissionDate: DateTime(2024, 5, 14, 17, 45),
      department: 'Customer Relations (CRM)',
      selectedRegisterIds: ['complaint'],
      notes: 'Customer query regarding missing price tag on organic tea resolved.',
      fileNames: ['Complaint_Log_Ticket89.docx'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDepartment = _operationsDepartments.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedRegisterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one register type')),
      );
      return;
    }

    final newSub = RegisterSubmission(
      id: 'reg-${DateTime.now().millisecondsSinceEpoch}',
      submissionDate: DateTime(2024, 5, 15, 9, 50),
      department: _selectedDepartment,
      selectedRegisterIds: _selectedRegisterIds.toList(),
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : 'Daily register update logged.',
      fileNames: List.from(_attachedFiles),
    );

    setState(() {
      _submissions.insert(0, newSub);
      _notesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registers updated successfully (Module 9)'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );

    _tabController.animateTo(1);
  }

  void _addFileMock() {
    setState(() {
      _attachedFiles.add('Register_Upload_${DateTime.now().minute}.xlsx');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Spreadsheet file attached successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final submissionDateStr = DateFormat('MMMM d, y hh:mm a').format(DateTime(2024, 5, 15, 9, 50));

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
          'Sections Registers Updates (Module 9)',
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
            const Tab(text: 'New Update'),
            Tab(text: 'History (${_submissions.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -----------------------------------------------------------------
          // Tab 1: New Update (Multi-select enabled)
          // -----------------------------------------------------------------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fact_check_rounded, color: Color(0xFF1D4ED8), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Category Selection: Multi-select enabled (Staff can choose one or more register types per submission).',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

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
                      // Submission Date (Non-editable)
                      _buildFieldLabel('Submission Date (System-generated)'),
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
                      const SizedBox(height: 14),

                      // Department (Operations Departments)
                      _buildFieldLabel('Department (Operations Departments)'),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedDepartment,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _operationsDepartments
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
                      const SizedBox(height: 14),

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
                      const SizedBox(height: 16),

                      // Type: The 9 Registers (Grouped by Category)
                      _buildFieldLabel('Select Register Types (Multi-select Enabled)'),
                      const SizedBox(height: 6),

                      // Inventory Group
                      _buildCategoryHeader('Inventory Registers'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AvailableRegisters.all
                            .where((r) => r.category == RegisterCategory.inventory)
                            .map((r) => _buildRegisterChip(r))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      // Sales & Operations Group
                      _buildCategoryHeader('Sales and Operations Registers'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AvailableRegisters.all
                            .where((r) => r.category == RegisterCategory.salesAndOperations)
                            .map((r) => _buildRegisterChip(r))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      // CRM Group
                      _buildCategoryHeader('CRM Registers'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AvailableRegisters.all
                            .where((r) => r.category == RegisterCategory.crm)
                            .map((r) => _buildRegisterChip(r))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Notes / Observation
                      _buildFieldLabel('Summary Notes / Highlights'),
                      TextField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter register quantities, variances, or summary...',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // File Uploads
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFieldLabel('Image / Excel / Word Attachments'),
                          TextButton.icon(
                            icon: const Icon(Icons.attach_file_rounded, size: 16),
                            label: const Text('Add File'),
                            onPressed: _addFileMock,
                          ),
                        ],
                      ),

                      ..._attachedFiles.map(
                        (f) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.description_rounded, size: 16, color: AppColors.primaryGreen),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

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
                            'Submit Register Updates',
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
              ],
            ),
          ),

          // -----------------------------------------------------------------
          // Tab 2: History Log
          // -----------------------------------------------------------------
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _submissions.length,
            itemBuilder: (context, index) {
              final sub = _submissions[index];
              final dateStr = DateFormat('MMM d, y hh:mm a').format(sub.submissionDate);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sub.department,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          dateStr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Register Badges
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: sub.registers.map((r) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: r.categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: r.categoryColor.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            r.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: r.categoryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (sub.notes != null && sub.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        sub.notes!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (sub.fileNames.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.primaryGreen),
                          const SizedBox(width: 4),
                          Text(
                            '${sub.fileNames.length} file(s) attached',
                            style: const TextStyle(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
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

  Widget _buildCategoryHeader(String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        category,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildRegisterChip(RegisterTypeItem r) {
    final isSelected = _selectedRegisterIds.contains(r.id);

    return FilterChip(
      label: Text(r.name),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedRegisterIds.add(r.id);
          } else {
            _selectedRegisterIds.remove(r.id);
          }
        });
      },
      selectedColor: r.categoryColor.withValues(alpha: 0.15),
      checkmarkColor: r.categoryColor,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? r.categoryColor : AppColors.textDark,
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide(
        color: isSelected ? r.categoryColor : const Color(0xFFE2E8F0),
      ),
    );
  }
}
