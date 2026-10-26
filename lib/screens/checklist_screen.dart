import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/checklist_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';
import '../widgets/notification_button.dart';
import 'arears_report_screen.dart';
import 'checklist_details_screen.dart';

class ChecklistScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;

  const ChecklistScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

enum ChecklistScreenView { overview, list }

class _ChecklistScreenState extends State<ChecklistScreen>
    with SingleTickerProviderStateMixin {
  ChecklistScreenView _currentView = ChecklistScreenView.overview;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSectionFilter;

  // 24 checklist items carefully configured to match the mockup:
  // 14 Completed, 7 Pending, 3 Arears (Total: 24)
  late List<ChecklistItem> _items;

  @override
  void initState() {
    super.initState();
    // Tabs order from mockup: All (24), Pending (7), Completed (14), Arears (3)
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _items = [
      // 1. Opening Checklist (Completed)
      ChecklistItem(
        id: 'chk-1',
        title: 'Opening Checklist',
        section: 'General',
        dueTime: '09:00 AM',
        status: ChecklistStatus.completed,
        description: 'Ensure all opening activities and safety procedures are verified before store opening.',
        subItems: [
          ChecklistSubItem(id: 's-1', title: 'Main shutters unlocked & inspected', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 's-2', title: 'AC units & lighting turned on', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 's-3', title: 'Security alarm disarmed', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 's-4', title: 'Cash registers float verification', isCompleted: true, answer: ChecklistAnswer.yes),
        ],
      ),
      // 2. Closing Checklist (Pending)
      ChecklistItem(
        id: 'chk-2',
        title: 'Closing Checklist',
        section: 'General',
        dueTime: '09:30 PM',
        status: ChecklistStatus.pending,
        description: 'Ensure all closing activities are completed before store closure.',
        subItems: [
          ChecklistSubItem(id: 'c-1', title: 'All billing counters closed', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 'c-2', title: 'Cash reconciliation completed'),
          ChecklistSubItem(id: 'c-3', title: 'All lights switched off'),
          ChecklistSubItem(id: 'c-4', title: 'All equipment switched off'),
          ChecklistSubItem(id: 'c-5', title: 'Security doors locked'),
          ChecklistSubItem(id: 'c-6', title: 'Floor cleaned & dry'),
          ChecklistSubItem(id: 'c-7', title: 'Waste bins emptied'),
          ChecklistSubItem(id: 'c-8', title: 'Closing announcement done'),
        ],
      ),
      // 3. Produce Section Checklist (Completed)
      ChecklistItem(
        id: 'chk-3',
        title: 'Produce Section Checklist',
        section: 'Produce',
        dueTime: '11:00 AM',
        status: ChecklistStatus.completed,
        description: 'Fresh vegetables and fruits misting, display grading, and freshness check.',
        subItems: [
          ChecklistSubItem(id: 'p-1', title: 'Vegetables misting system active', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 'p-2', title: 'Bruised items culled out', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 'p-3', title: 'Price tags aligned with crates', isCompleted: true, answer: ChecklistAnswer.yes),
        ],
      ),
      // 4. Dairy Section Checklist (Pending)
      ChecklistItem(
        id: 'chk-4',
        title: 'Dairy Section Checklist',
        section: 'Dairy',
        dueTime: '11:30 AM',
        status: ChecklistStatus.pending,
        description: 'Milk bottles, yogurts, and cheeses temperature and expiry date rotation check.',
        subItems: [
          ChecklistSubItem(id: 'd-1', title: 'Chiller temp below 4°C verified', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 'd-2', title: 'Milk packs date code checked'),
          ChecklistSubItem(id: 'd-3', title: 'Yogurt rack fronted & faced'),
        ],
      ),
      // 5. Bakery Section Checklist (Arears)
      ChecklistItem(
        id: 'chk-5',
        title: 'Bakery Section Checklist',
        section: 'Bakery',
        dueTime: '12:00 PM',
        status: ChecklistStatus.arears,
        notes: 'Pastry oven temperature log was missed during rush hour.',
        description: 'Oven temperature calibration, morning bread batch inspection, and display setup.',
        subItems: [
          ChecklistSubItem(id: 'b-1', title: 'Oven pre-heat temp log'),
          ChecklistSubItem(id: 'b-2', title: 'Baking sheet sanitization check'),
        ],
      ),
      // 6. Housekeeping Checklist (Completed)
      ChecklistItem(
        id: 'chk-6',
        title: 'Housekeeping Checklist',
        section: 'General',
        dueTime: '02:00 PM',
        status: ChecklistStatus.completed,
        description: 'Customer restrooms, main aisle cleanliness, and spill response equipment.',
        subItems: [
          ChecklistSubItem(id: 'h-1', title: 'Aisle 1-6 mop verified', isCompleted: true, answer: ChecklistAnswer.yes),
          ChecklistSubItem(id: 'h-2', title: 'Restroom soap & towel dispensers', isCompleted: true, answer: ChecklistAnswer.yes),
        ],
      ),
      // 7. Special Sales Checklist (Pending)
      ChecklistItem(
        id: 'chk-7',
        title: 'Special Sales Checklist',
        section: 'Sales',
        dueTime: '03:00 PM',
        status: ChecklistStatus.pending,
        description: 'Afternoon flash discount tags verification on promotional end-caps.',
        subItems: [
          ChecklistSubItem(id: 's-1', title: 'Discount signs posted on gondolas'),
          ChecklistSubItem(id: 's-2', title: 'Bundle offers scanned at POS'),
        ],
      ),
      // 8. FEFO Tracking Checklist (Pending)
      ChecklistItem(
        id: 'chk-8',
        title: 'FEFO Tracking Checklist',
        section: 'Inventory',
        dueTime: '04:00 PM',
        status: ChecklistStatus.pending,
        description: 'First-Expired First-Out fronting on chilled beverage rack and dairy aisles.',
        subItems: [
          ChecklistSubItem(id: 'f-1', title: 'Juice fridge expiry audit'),
          ChecklistSubItem(id: 'f-2', title: 'Older stock pushed to front'),
        ],
      ),
      // 9. CRM Addition Checklist (Pending)
      ChecklistItem(
        id: 'chk-9',
        title: 'CRM Addition Checklist',
        section: 'CRM',
        dueTime: '05:00 PM',
        status: ChecklistStatus.pending,
        description: 'Enroll new loyalty customers into supermarket rewards system.',
        subItems: [
          ChecklistSubItem(id: 'crm-1', title: 'Cashier loyalty enroll count verification'),
          ChecklistSubItem(id: 'crm-2', title: 'Member points balance queries solved'),
        ],
      ),
      // 10. Display Re Arrangement Checklist (Pending)
      ChecklistItem(
        id: 'chk-10',
        title: 'Display Re Arrangement Checklist',
        section: 'Visual',
        dueTime: '06:00 PM',
        status: ChecklistStatus.pending,
        description: 'Snack and chocolate gondola restock and planogram setup.',
        subItems: [
          ChecklistSubItem(id: 'v-1', title: 'End-cap chocolate promotion organized'),
          ChecklistSubItem(id: 'v-2', title: 'Damaged packaging removed from display'),
        ],
      ),
      // 11. Chiller Temperature Checklist (Completed)
      ChecklistItem(
        id: 'chk-11',
        title: 'Chiller Temp Log (< 4°C)',
        section: 'Dairy',
        dueTime: '07:30 AM',
        status: ChecklistStatus.completed,
        description: 'Chillers reading 3.2°C, optimal cooling maintained.',
      ),
      // 12. Deep Freezer Temperature Checklist (Completed)
      ChecklistItem(
        id: 'chk-12',
        title: 'Deep Freezer Temp Log (< -18°C)',
        section: 'Frozen',
        dueTime: '07:45 AM',
        status: ChecklistStatus.completed,
        description: 'Freezer temperature stable at -19.5°C.',
      ),
      // 13. Fresh Bakery Morning Bake (Completed)
      ChecklistItem(
        id: 'chk-13',
        title: 'Fresh Bakery Morning Inspection',
        section: 'Bakery',
        dueTime: '08:00 AM',
        status: ChecklistStatus.completed,
        description: 'Morning bread and croissants batch freshness confirmed.',
      ),
      // 14. POS Cash Register Balancing (Completed)
      ChecklistItem(
        id: 'chk-14',
        title: 'POS Float Balancing',
        section: 'Cashier',
        dueTime: '08:30 AM',
        status: ChecklistStatus.completed,
        description: 'Float cash counters reconciled for tills 1 through 6.',
      ),
      // 15. Floor Wet Cleaning Check (Completed)
      ChecklistItem(
        id: 'chk-15',
        title: 'Floor Wet Cleaning & Sanitization Signs',
        section: 'Hygiene',
        dueTime: '09:00 AM',
        status: ChecklistStatus.completed,
        description: 'Wet floor hazard signs placed correctly during morning wash.',
      ),
      // 16. Customer Trolleys Sanitization (Completed)
      ChecklistItem(
        id: 'chk-16',
        title: 'Customer Trolleys & Baskets Sanitization',
        section: 'Hygiene',
        dueTime: '09:30 AM',
        status: ChecklistStatus.completed,
        description: 'All 120 entry carts and baskets wiped with sanitizer.',
      ),
      // 17. Butchery Section Hygiene (Completed)
      ChecklistItem(
        id: 'chk-17',
        title: 'Meat & Butchery Sanitization Routine',
        section: 'Butchery',
        dueTime: '10:00 AM',
        status: ChecklistStatus.completed,
        description: 'Cutting boards and knife sterilizers verified clean.',
      ),
      // 18. Emergency Exit Clearance Check (Completed)
      ChecklistItem(
        id: 'chk-18',
        title: 'Emergency Exit Pathways Clearance',
        section: 'Safety',
        dueTime: '10:30 AM',
        status: ChecklistStatus.completed,
        description: 'All fire exits and corridors free of pallets.',
      ),
      // 19. Trash Disposal Morning Cycle (Completed)
      ChecklistItem(
        id: 'chk-19',
        title: 'Waste Bin Emptying & Compactor Check',
        section: 'Hygiene',
        dueTime: '11:00 AM',
        status: ChecklistStatus.completed,
        description: 'Rear loading dock trash compactor operated cleanly.',
      ),
      // 20. Produce Scale Calibration (Completed)
      ChecklistItem(
        id: 'chk-20',
        title: 'Weighing Scales Zero-Weight Calibration',
        section: 'Produce',
        dueTime: '11:30 AM',
        status: ChecklistStatus.completed,
        description: 'Electronic scales 1-4 tested with standard weights.',
      ),
      // 21. Staff Uniform & Grooming Audit (Completed)
      ChecklistItem(
        id: 'chk-21',
        title: 'Staff Grooming & Badge Inspection',
        section: 'HR',
        dueTime: '12:00 PM',
        status: ChecklistStatus.completed,
        description: 'Floor associates adhering to apron and hairnet guidelines.',
      ),
      // 22. Night Shift Handover Checklist (Pending)
      ChecklistItem(
        id: 'chk-22',
        title: 'Night Shift Handover Checklist',
        section: 'General',
        dueTime: '10:00 PM',
        status: ChecklistStatus.pending,
        description: 'Keys, cash safe access log, and night stocker briefing.',
      ),
      // 23. Price Tag Discrepancy Audit (Arears)
      ChecklistItem(
        id: 'chk-23',
        title: 'Display Re-Arrangement Checklist',
        section: 'Visual',
        dueTime: '11:00 PM',
        status: ChecklistStatus.arears,
        notes: 'Late night visual end-caps planogram pending supervisor check.',
      ),
      // 24. Expired Stock Pull Checklist (Arears)
      ChecklistItem(
        id: 'chk-24',
        title: 'Stock Audit Checklist',
        section: 'Inventory',
        dueTime: '10:00 AM',
        status: ChecklistStatus.arears,
        notes: 'Morning pull checklist not signed off before store opening.',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int get _totalCount => _items.length;
  int get _completedCount =>
      _items.where((i) => i.status == ChecklistStatus.completed).length;
  int get _pendingCount =>
      _items.where((i) => i.status == ChecklistStatus.pending).length;
  int get _arearsCount =>
      _items.where((i) => i.status == ChecklistStatus.arears).length;

  int get _completedPercent =>
      _totalCount > 0 ? ((_completedCount / _totalCount) * 100).round() : 0;
  int get _pendingPercent =>
      _totalCount > 0 ? ((_pendingCount / _totalCount) * 100).round() : 0;
  int get _arearsPercent =>
      _totalCount > 0 ? ((_arearsCount / _totalCount) * 100).round() : 0;

  void _navigateToList(int tabIndex) {
    setState(() {
      _currentView = ChecklistScreenView.list;
      _tabController.index = tabIndex;
    });
  }

  void _openDetails(ChecklistItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ChecklistDetailsScreen(
          item: item,
          onUpdated: () => setState(() {}),
        ),
      ),
    );
    setState(() {});
  }

  void _openArearsReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ArearsReportScreen(
          items: _items,
          onNavigateToTab: (index) {
            _navigateToList(index);
          },
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.state.selectedDate,
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
      widget.state.setSelectedDate(picked);
    }
  }

  void _showAddChecklistModal() {
    final titleController = TextEditingController();
    String selectedSection = 'General';
    String dueTime = '04:00 PM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Checklist',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Checklist Title',
                      hintText: 'e.g. Evening Chillers Audit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: selectedSection,
                          decoration: InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'General', child: Text('General')),
                            DropdownMenuItem(value: 'Produce', child: Text('Produce')),
                            DropdownMenuItem(value: 'Dairy', child: Text('Dairy')),
                            DropdownMenuItem(value: 'Bakery', child: Text('Bakery')),
                            DropdownMenuItem(value: 'Inventory', child: Text('Inventory')),
                            DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                            DropdownMenuItem(value: 'Visual', child: Text('Visual')),
                          ],
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedSection = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Due Time',
                            hintText: 'e.g. 05:00 PM',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (v) => dueTime = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isNotEmpty) {
                          setState(() {
                            _items.insert(
                              0,
                              ChecklistItem(
                                id: 'chk-${DateTime.now().millisecondsSinceEpoch}',
                                title: titleController.text.trim(),
                                section: selectedSection,
                                dueTime: dueTime,
                                status: ChecklistStatus.pending,
                                subItems: [
                                  ChecklistSubItem(id: 'n-1', title: 'Checkpoint 1 inspection'),
                                  ChecklistSubItem(id: 'n-2', title: 'Sign-off and log records'),
                                ],
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New checklist created successfully'),
                              backgroundColor: Color(0xFF16A34A),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Create Checklist',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterModal() {
    final sections = [
      'All Sections',
      'General',
      'Produce',
      'Dairy',
      'Bakery',
      'Sales',
      'Inventory',
      'CRM',
      'Visual',
      'Hygiene',
      'Safety',
      'Frozen',
      'Cashier',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter by Department',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sections.map((sec) {
                    final isSelected =
                        (_selectedSectionFilter == null && sec == 'All Sections') ||
                        _selectedSectionFilter == sec;
                    return ChoiceChip(
                      label: Text(sec),
                      selected: isSelected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textDark,
                      ),
                      backgroundColor: const Color(0xFFF1F5F9),
                      onSelected: (selected) {
                        setState(() {
                          _selectedSectionFilter = sec == 'All Sections' ? null : sec;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentView == ChecklistScreenView.overview,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentView == ChecklistScreenView.list) {
          setState(() {
            _currentView = ChecklistScreenView.overview;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildAppBar(),
        body: _currentView == ChecklistScreenView.overview
            ? _buildOverviewBody()
            : _buildListBody(),
        floatingActionButton: _currentView == ChecklistScreenView.overview
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.primaryGreen,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  'Add Checklist',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                onPressed: _showAddChecklistModal,
              )
            : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentView == ChecklistScreenView.overview) {
      return AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          onPressed: widget.onOpenDrawer,
        ),
        title: const DayFreshLogo(scale: 0.95, isDarkBackground: true),
        centerTitle: true,
        actions: [
          NotificationBellButton(
            count: widget.state.unreadNotifications,
            onTap: () => widget.state.clearNotifications(),
          ),
          const SizedBox(width: 4),
        ],
      );
    } else {
      final isArearsTab = _tabController.index == 3;

      return AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _currentView = ChecklistScreenView.overview;
            });
          },
        ),
        title: Text(
          isArearsTab ? 'Arears' : 'Daily Checklist',
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
            onTap: () => widget.state.clearNotifications(),
          ),
          const SizedBox(width: 4),
        ],
      );
    }
  }

  // ----------------------------------------------------
  // OVERVIEW SCREEN (Screens 1 & 2 in user's image)
  // ----------------------------------------------------
  Widget _buildOverviewBody() {
    final formattedDate = DateFormat('MMMM d, y').format(widget.state.selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Manager Greeting & View Arears Report
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, color: AppColors.textMuted, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hi, Juan Dela Cruz',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                        ],
                      ),
                      Text(
                        'Store Manager',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: _openArearsReport,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View Arears Report',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Section Title
          Text(
            'Daily Checklist Overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Date Row with Calendar Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                  color: AppColors.textMuted,
                ),
                onPressed: _pickDate,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Metric cards row in a single card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildOverviewStatCard(
                  label: 'Total',
                  value: '$_totalCount',
                  badge: '10%',
                  badgeBg: const Color(0xFFE8F5E9),
                  badgeTextColor: const Color(0xFF16A34A),
                  onTap: () => _navigateToList(0),
                ),
                _buildDivider(),
                _buildOverviewStatCard(
                  label: 'Completed',
                  value: '$_completedCount',
                  badge: '$_completedPercent%',
                  badgeBg: const Color(0xFFE8F5E9),
                  badgeTextColor: const Color(0xFF16A34A),
                  onTap: () => _navigateToList(2),
                ),
                _buildDivider(),
                _buildOverviewStatCard(
                  label: 'Pending',
                  value: '$_pendingCount',
                  badge: '$_pendingPercent%',
                  badgeBg: const Color(0xFFFFF7ED),
                  badgeTextColor: const Color(0xFFF97316),
                  onTap: () => _navigateToList(1),
                ),
                _buildDivider(),
                _buildOverviewStatCard(
                  label: 'Arears',
                  value: '$_arearsCount',
                  badge: '$_arearsPercent%',
                  badgeBg: const Color(0xFFFEF2F2),
                  badgeTextColor: const Color(0xFFEF4444),
                  onTap: () => _navigateToList(3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Checklist Breakup Section
          Text(
            'Checklist Breakup',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Donut Chart Card with Legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Custom Donut Chart
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CustomPaint(
                    painter: _ChecklistDonutPainter(
                      completed: _completedCount.toDouble(),
                      pending: _pendingCount.toDouble(),
                      arears: _arearsCount.toDouble(),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_totalCount',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 22),

                // Legend Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBreakupLegendItem(
                        color: const Color(0xFF16A34A),
                        label: 'Completed',
                        value: '$_completedCount ($_completedPercent%)',
                        onTap: () => _navigateToList(2),
                      ),
                      const SizedBox(height: 12),
                      _buildBreakupLegendItem(
                        color: const Color(0xFFF97316),
                        label: 'Pending',
                        value: '$_pendingCount ($_pendingPercent%)',
                        onTap: () => _navigateToList(1),
                      ),
                      const SizedBox(height: 12),
                      _buildBreakupLegendItem(
                        color: const Color(0xFFEF4444),
                        label: 'Arears',
                        value: '$_arearsCount ($_arearsPercent%)',
                        onTap: () => _navigateToList(3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Today's Status Section
          Text(
            "Today's Status",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Today's Status Items Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStatusRow(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFE8F8F0),
                  title: 'Completed',
                  subtitle: '$_completedCount Checklists',
                  percent: '$_completedPercent%',
                  percentColor: const Color(0xFF16A34A),
                  percentBg: const Color(0xFFE8F5E9),
                  onTap: () => _navigateToList(2),
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildStatusRow(
                  icon: Icons.access_time_filled_rounded,
                  iconColor: const Color(0xFFF97316),
                  iconBg: const Color(0xFFFFF7ED),
                  title: 'Pending',
                  subtitle: '$_pendingCount Checklists',
                  percent: '$_pendingPercent%',
                  percentColor: const Color(0xFFF97316),
                  percentBg: const Color(0xFFFFF7ED),
                  onTap: () => _navigateToList(1),
                ),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _buildStatusRow(
                  icon: Icons.error_rounded,
                  iconColor: const Color(0xFFEF4444),
                  iconBg: const Color(0xFFFEF2F2),
                  title: 'Arears',
                  subtitle: '$_arearsCount Checklists',
                  percent: '$_arearsPercent%',
                  percentColor: const Color(0xFFEF4444),
                  percentBg: const Color(0xFFFEF2F2),
                  onTap: () => _navigateToList(3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // View Arears Report Action
          Center(
            child: InkWell(
              onTap: _openArearsReport,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Arears Report',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60), // Room for FAB
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 38, color: const Color(0xFFF1F5F9));
  }

  Widget _buildOverviewStatCard({
    required String label,
    required String value,
    required String badge,
    required Color badgeBg,
    required Color badgeTextColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakupLegendItem({
    required Color color,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String percent,
    required Color percentColor,
    required Color percentBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: percentBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                percent,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: percentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // LIST VIEW SCREEN (Screens 3, 4, 7 in user's image)
  // ----------------------------------------------------
  Widget _buildListBody() {
    return Column(
      children: [
        // Tabs Header matching mockup: All (24), Pending (7), Completed (14), Arears (3)
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            indicatorColor: AppColors.primaryGreen,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'All ($_totalCount)'),
              Tab(text: 'Pending ($_pendingCount)'),
              Tab(text: 'Completed ($_completedCount)'),
              Tab(text: 'Arears ($_arearsCount)'),
            ],
          ),
        ),

        // Search Bar & Filter Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search checklist...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 16,
                                color: AppColors.textLight,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _showFilterModal,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: _selectedSectionFilter != null
                        ? AppColors.primaryGreen
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedSectionFilter != null
                          ? AppColors.primaryGreen
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _selectedSectionFilter != null
                        ? Colors.white
                        : AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Active filter indicator if selected
        if (_selectedSectionFilter != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Department: $_selectedSectionFilter',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedSectionFilter = null;
                    });
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),

        // Checklist List Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildChecklistList(null), // All
              _buildChecklistList(ChecklistStatus.pending), // Pending
              _buildChecklistList(ChecklistStatus.completed), // Completed
              _buildChecklistList(ChecklistStatus.arears), // Arears
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistList(ChecklistStatus? statusFilter) {
    var filtered = _items;

    if (statusFilter != null) {
      filtered = filtered.where((i) => i.status == statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (i) =>
                i.title.toLowerCase().contains(q) ||
                i.section.toLowerCase().contains(q),
          )
          .toList();
    }

    if (_selectedSectionFilter != null) {
      filtered = filtered
          .where((i) => i.section == _selectedSectionFilter)
          .toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.checklist_rtl_rounded,
                size: 54,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                'No checklists found',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              if (_searchQuery.isNotEmpty || _selectedSectionFilter != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Try modifying your search or filter',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return _buildChecklistCard(item);
      },
    );
  }

  Widget _buildChecklistCard(ChecklistItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openDetails(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checklist Title
                      Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Department / Section name
                      Text(
                        item.section,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Due time
                      Text(
                        'Due: ${item.dueTime}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Status Badge on Right
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.statusLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: item.statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Custom Painter for the Checklist Breakup Donut Chart
// -----------------------------------------------------------------------
class _ChecklistDonutPainter extends CustomPainter {
  final double completed;
  final double pending;
  final double arears;

  _ChecklistDonutPainter({
    required this.completed,
    required this.pending,
    required this.arears,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = completed + pending + arears;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 12.0;

    final paintCompleted = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final paintPending = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final paintArears = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    const gap = 0.08;

    final sweepArears = (arears / total) * 2 * math.pi;
    if (sweepArears > gap) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepArears - gap,
        false,
        paintArears,
      );
    }
    startAngle += sweepArears;

    final sweepCompleted = (completed / total) * 2 * math.pi;
    if (sweepCompleted > gap) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepCompleted - gap,
        false,
        paintCompleted,
      );
    }
    startAngle += sweepCompleted;

    final sweepPending = (pending / total) * 2 * math.pi;
    if (sweepPending > gap) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepPending - gap,
        false,
        paintPending,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChecklistDonutPainter oldDelegate) {
    return oldDelegate.completed != completed ||
        oldDelegate.pending != pending ||
        oldDelegate.arears != arears;
  }
}
