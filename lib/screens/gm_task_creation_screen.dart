import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';

class GmTaskCreationScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;

  const GmTaskCreationScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
  });

  @override
  State<GmTaskCreationScreen> createState() => _GmTaskCreationScreenState();
}

class _GmTaskCreationScreenState extends State<GmTaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _branches = [
    'DayFresh Hypermarket #104 - City Center (Kochi)',
    'DayFresh Supercenter - Edappally',
    'DayFresh Flagship Store - Calicut',
    'DayFresh Express - Trivandrum South',
  ];

  final List<String> _departments = [
    'Fresh Produce',
    'Dairy & Chilled Foods',
    'Meat & Butchery',
    'Fresh Bakery',
    'Dry Grocery & Beverages',
    'Household & Personal Care',
    'Inventory & Warehouse',
    'Sales and Operations',
    'Customer Relations (CRM)',
  ];

  late String _selectedBranch;
  late String _selectedDepartment;
  String _executionLevel = 'Mid-Level'; // 'Mid-Level' or 'Lower-Level'
  String _assignedTo = 'Maria Santos (Dept. Manager)';

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();

  DateTime _targetedExecutionDate = DateTime(2024, 5, 15, 10, 0);
  DateTime _deadline = DateTime(2024, 5, 15, 16, 0);

  @override
  void initState() {
    super.initState();
    _selectedBranch = _branches.first;
    _selectedDepartment = _departments.first;
    _updateAssigneeList();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDetailsController.dispose();
    super.dispose();
  }

  void _updateAssigneeList() {
    if (_executionLevel == 'Mid-Level') {
      switch (_selectedDepartment) {
        case 'Fresh Produce':
          _assignedTo = 'Maria Santos (Produce Manager)';
          break;
        case 'Dairy & Chilled Foods':
          _assignedTo = 'Ahmed Khan (Dairy Manager)';
          break;
        case 'Meat & Butchery':
          _assignedTo = 'Elena Rostova (Butchery Lead)';
          break;
        case 'Fresh Bakery':
          _assignedTo = 'Priya Sharma (Bakery Head)';
          break;
        case 'Inventory & Warehouse':
          _assignedTo = 'Suresh Kumar (Inventory Lead)';
          break;
        default:
          _assignedTo = 'Juan Dela Cruz (Store Operations Manager)';
      }
    } else {
      _assignedTo = '$_selectedDepartment Floor Associates Team';
    }
  }

  List<String> _getAvailableAssignees() {
    if (_executionLevel == 'Mid-Level') {
      return [
        'Maria Santos (Produce Manager)',
        'Ahmed Khan (Dairy Manager)',
        'Elena Rostova (Butchery Lead)',
        'Priya Sharma (Bakery Head)',
        'David Chen (Grocery Supervisor)',
        'Suresh Kumar (Inventory Lead)',
        'Juan Dela Cruz (Store Operations Manager)',
      ];
    } else {
      return [
        '$_selectedDepartment Floor Associates Team',
        'Morning Shift Stockers (Team A)',
        'Evening Shift Handover Crew',
        'Quality & Expiry Audit Associate',
      ];
    }
  }

  void _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetedExecutionDate,
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
        _targetedExecutionDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _targetedExecutionDate.hour,
          _targetedExecutionDate.minute,
        );
      });
    }
  }

  void _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
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
        _deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _deadline.hour,
          _deadline.minute,
        );
      });
    }
  }

  void _createTask() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.state.createTaskByGM(
        branch: _selectedBranch,
        title: _taskNameController.text.trim(),
        details: _taskDetailsController.text.trim(),
        targetExecutionDate: _targetedExecutionDate,
        deadline: _deadline,
        department: _selectedDepartment,
        executionLevel: _executionLevel,
        assignedTo: _assignedTo,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Task "${_taskNameController.text.trim()}" dispatched to $_assignedTo!',
          ),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 3),
        ),
      );

      _taskNameController.clear();
      _taskDetailsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetStr = DateFormat('MMM d, y (hh:mm a)').format(_targetedExecutionDate);
    final deadlineStr = DateFormat('MMM d, y (hh:mm a)').format(_deadline);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          onPressed: widget.onOpenDrawer,
        ),
        title: Row(
          children: [
            const DayFreshLogo(scale: 0.85, isDarkBackground: true),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'GM INTERFACE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // User Details and Icon (From user's spreadsheet header: Branding on left, User Details on right)
          PopupMenuButton<String>(
            tooltip: 'User Details',
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
              ],
            ),
            onSelected: (val) {
              if (val == 'switch_staff') {
                widget.state.switchUserRole(UserRole.staff);
              } else if (val == 'logout') {
                widget.state.logout();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.state.currentUser.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      widget.state.currentUser.role,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'switch_staff',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.primaryGreen),
                    SizedBox(width: 8),
                    Text('Switch to Staff Interface'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Log Out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GM Interface Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFFBBF24), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'General Manager Control Hub',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Create and assign operational tasks directly to department managers and store teams.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: Colors.white70,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Section Header: A: Tasks Module - Create New Task
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'MODULE A',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Create New Task',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Supervisors & MA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Form Card matching the GM Interface Spreadsheet exactly
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Branch Dropdown (Dropdown option to select branch)
                    _buildFieldLabel('Branch (Dropdown option to select branch)'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedBranch,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.storefront_rounded, size: 20),
                      ),
                      items: _branches
                          .map((b) => DropdownMenuItem(
                                value: b,
                                child: Text(
                                  b,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedBranch = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // 2. Tasks Name (Text Field)
                    _buildFieldLabel('Tasks Name (Text Field)'),
                    TextFormField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. End-Cap Promotional Display Re-arrangement',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter task name' : null,
                    ),
                    const SizedBox(height: 14),

                    // 3. Tasks Details (Paragraph)
                    _buildFieldLabel('Tasks Details (Paragraph)'),
                    TextFormField(
                      controller: _taskDetailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe target SKUs, planogram specifications, and expected checklist compliance...',
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter task details' : null,
                    ),
                    const SizedBox(height: 14),

                    // 4 & 5. Targeted Execution Date & Deadline (Date pickers)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Targeted Execution Date'),
                              InkWell(
                                onTap: _pickTargetDate,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                    color: const Color(0xFFF8FAFC),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_circle_outline_rounded, size: 18, color: AppColors.primaryGreen),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          targetStr,
                                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Deadline'),
                              InkWell(
                                onTap: _pickDeadline,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                    color: const Color(0xFFF8FAFC),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.alarm_rounded, size: 18, color: Color(0xFFEF4444)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          deadlineStr,
                                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 6. Department Dropdown (Inc all department)
                    _buildFieldLabel('Department (Dropdown inc all department)'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedDepartment,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.category_rounded, size: 20),
                      ),
                      items: _departments
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(
                                  d,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedDepartment = val;
                            _updateAssigneeList();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // 7. Execution Level (Mid-Level vs Lower-Level)
                    _buildFieldLabel('Execution Level'),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _executionLevel = 'Mid-Level';
                                _updateAssigneeList();
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _executionLevel == 'Mid-Level'
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _executionLevel == 'Mid-Level'
                                      ? AppColors.primaryGreen
                                      : const Color(0xFFE2E8F0),
                                  width: _executionLevel == 'Mid-Level' ? 1.8 : 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _executionLevel == 'Mid-Level'
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        size: 16,
                                        color: _executionLevel == 'Mid-Level'
                                            ? AppColors.primaryGreen
                                            : AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Mid-Level',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _executionLevel == 'Mid-Level'
                                              ? AppColors.primaryGreen
                                              : AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Assigned directly to Dept. Manager',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _executionLevel = 'Lower-Level';
                                _updateAssigneeList();
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _executionLevel == 'Lower-Level'
                                    ? const Color(0xFFEFF6FF)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _executionLevel == 'Lower-Level'
                                      ? const Color(0xFF0284C7)
                                      : const Color(0xFFE2E8F0),
                                  width: _executionLevel == 'Lower-Level' ? 1.8 : 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _executionLevel == 'Lower-Level'
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        size: 16,
                                        color: _executionLevel == 'Lower-Level'
                                            ? const Color(0xFF0284C7)
                                            : AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Lower-Level',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _executionLevel == 'Lower-Level'
                                              ? const Color(0xFF0284C7)
                                              : AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Created by GM → Notifies Dept.',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 8. Assigned To (Dynamic dropdown based on execution level and department)
                    _buildFieldLabel('Assigned To (Dynamic dropdown based on level & dept)'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      key: ValueKey('$_executionLevel-$_selectedDepartment'),
                      initialValue: _getAvailableAssignees().contains(_assignedTo)
                          ? _assignedTo
                          : _getAvailableAssignees().first,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.person_pin_rounded, size: 20),
                      ),
                      items: _getAvailableAssignees()
                          .map((a) => DropdownMenuItem(
                                value: a,
                                child: Text(
                                  a,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _assignedTo = val);
                      },
                    ),
                    const SizedBox(height: 22),

                    // Create Button (Create button from spreadsheet bottom right)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: _createTask,
                        child: Text(
                          'Create Task',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // GM Dispatched Tasks Log
            Text(
              'Dispatched Tasks Overview (${widget.state.pendingTasks.length} Pending)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            ...widget.state.pendingTasks.take(5).map((t) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            t.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Pending Execution',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFF97316)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t.department} • Assigned To: ${t.submitterName}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
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
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
