import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class AppState extends ChangeNotifier {
  // Authentication & Profile state
  bool _isAuthenticated = false;
  UserModel _currentUser = UserModel.defaultStaff;

  DateTime _selectedDate = DateTime(2024, 5, 15);
  int _currentNavIndex = 0;
  int _unreadNotifications = 1;
  String _taskSearchQuery = '';
  String _submittedSearchQuery = '';
  int _submittedTabFilter = 0; // 0: All, 1: Today, 2: This Week

  // Initial Task dataset carefully aligned with the mockups
  final List<TaskItem> _tasks = [
    // --- Pending Tasks (5) ---
    TaskItem(
      id: 'task-1',
      title: 'Stock Audit',
      time: '10:00 AM',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      description: 'Verify and record the current stock levels for all categories and ensure accuracy.',
      skuCount: 250,
      discrepancyFound: true,
      discrepancyDetails: '5 items with quantity mismatch',
      actionsTaken: 'Corrected quantities and informed team',
      photoUrls: [
        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60',
      ],
      category: 'Inventory',
    ),
    TaskItem(
      id: 'task-2',
      title: 'Aged Stock Clearance',
      time: '11:00 AM',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      description: 'Check products nearing expiry date within 7 days and move to marked discount section.',
      skuCount: 84,
      discrepancyFound: false,
      actionsTaken: 'Discount tags applied and shifted to front gondola',
      photoUrls: [
        'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=500&auto=format&fit=crop&q=60',
      ],
      category: 'Merchandising',
    ),
    TaskItem(
      id: 'task-3',
      title: 'Display Re Arrangement',
      time: '01:00 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      description: 'Realign promotional snack aisle end-caps according to May marketing planogram.',
      category: 'Floor Setup',
    ),
    TaskItem(
      id: 'task-4',
      title: 'FEFO Tracking',
      time: '02:00 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      description: 'First Expire First Out routine on Dairy, Chilled Beverages, and Prepared Salads.',
      category: 'Fresh Food',
    ),
    TaskItem(
      id: 'task-5',
      title: 'Special Sales Target',
      time: '04:00 PM',
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      description: 'Review hourly sales report against daily target for household essentials.',
      category: 'Sales Analytics',
    ),

    // --- Submitted Tasks (7) ---
    TaskItem(
      id: 'sub-1',
      title: 'Stock Audit',
      time: '09:45 AM',
      priority: TaskPriority.high,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 9, 45),
      description: 'Verify and record the current stock levels for all categories and ensure accuracy.',
      skuCount: 250,
      discrepancyFound: true,
      discrepancyDetails: '5 items with quantity mismatch',
      actionsTaken: 'Corrected quantities and informed team',
      photoUrls: [
        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=60',
      ],
    ),
    TaskItem(
      id: 'sub-2',
      title: 'Aged Stock Clearance',
      time: '11:30 AM',
      priority: TaskPriority.high,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 11, 30),
      description: 'Check products nearing expiry date within 7 days and move to clearance.',
      skuCount: 42,
      discrepancyFound: false,
      actionsTaken: 'Yellow tags affixed and logged in ERP',
    ),
    TaskItem(
      id: 'sub-3',
      title: 'Display Re Arrangement',
      time: '01:15 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 13, 15),
      description: 'Realign promotional snack aisle end-caps according to planogram.',
      skuCount: 120,
      discrepancyFound: false,
      actionsTaken: 'Shelves wiped and header banners updated',
    ),
    TaskItem(
      id: 'sub-4',
      title: 'FEFO Tracking',
      time: '02:45 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 14, 45),
      description: 'First Expire First Out routine on Dairy and Chilled Beverages.',
      skuCount: 190,
      discrepancyFound: true,
      discrepancyDetails: '3 milk cartons expired tomorrow placed at rear',
      actionsTaken: 'Fronted short-dated cartons and notified floor staff',
    ),
    TaskItem(
      id: 'sub-5',
      title: 'Special Sales Target',
      time: '04:30 PM',
      priority: TaskPriority.low,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 16, 30),
      description: 'Review afternoon sales report against daily target.',
      skuCount: 340,
      discrepancyFound: false,
      actionsTaken: 'Report printed and submitted to floor head',
    ),
    TaskItem(
      id: 'sub-6',
      title: 'CRM Addition',
      time: '05:00 PM',
      priority: TaskPriority.low,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 17, 0),
      description: 'Customer loyalty program signup numbers consolidation.',
      skuCount: 45,
      discrepancyFound: false,
      actionsTaken: 'Registered 45 loyalty members in CRM portal',
    ),
    TaskItem(
      id: 'sub-7',
      title: 'Cold Storage Inspection',
      time: '08:15 AM',
      priority: TaskPriority.high,
      status: TaskStatus.submitted,
      submittedAt: DateTime(2024, 5, 15, 8, 15),
      description: 'Freezer and chiller unit temperature validation log.',
      skuCount: 16,
      discrepancyFound: false,
      actionsTaken: 'Logged temperatures: Chiller 2.8°C, Freezer -19.2°C',
    ),
  ];

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  UserModel get currentUser => _currentUser;
  DateTime get selectedDate => _selectedDate;
  int get currentNavIndex => _currentNavIndex;
  int get unreadNotifications => _unreadNotifications;
  String get taskSearchQuery => _taskSearchQuery;
  String get submittedSearchQuery => _submittedSearchQuery;
  int get submittedTabFilter => _submittedTabFilter;

  List<TaskItem> get allTasks => List.unmodifiable(_tasks);

  List<TaskItem> get pendingTasks => _tasks
      .where((t) => t.status == TaskStatus.pending)
      .toList();

  List<TaskItem> get submittedTasks => _tasks
      .where((t) => t.status == TaskStatus.submitted)
      .toList();

  int get totalTasksCount => _tasks.length;
  int get pendingTasksCount => pendingTasks.length;
  int get submittedTasksCount => submittedTasks.length;

  int get progressPercentage {
    if (totalTasksCount == 0) return 0;
    return ((submittedTasksCount / totalTasksCount) * 100).round();
  }

  // Authentication actions
  void loginWithPhone({
    required String phone,
    String? name,
    String? role,
    String? branch,
    String? employeeId,
  }) {
    _currentUser = UserModel(
      name: name ?? _currentUser.name,
      phone: phone,
      role: role ?? _currentUser.role,
      storeBranch: branch ?? _currentUser.storeBranch,
      employeeId: employeeId ?? _currentUser.employeeId,
    );
    _isAuthenticated = true;
    _currentNavIndex = 0;
    notifyListeners();
  }

  void registerStaff({
    required String name,
    required String phone,
    required String role,
    required String storeBranch,
    String? employeeId,
  }) {
    _currentUser = UserModel(
      name: name,
      phone: phone,
      role: role,
      storeBranch: storeBranch,
      employeeId: employeeId ?? 'DF-${(1000 + DateTime.now().millisecond % 9000)}',
    );
    _isAuthenticated = true;
    _currentNavIndex = 0;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentNavIndex = 0;
    notifyListeners();
  }

  void bypassAuthForDemo() {
    _isAuthenticated = true;
    notifyListeners();
  }

  bool get isGeneralManager => _currentUser.isGeneralManager;
  bool get isStoreManager => _currentUser.isStoreManager;
  bool get isStaff => _currentUser.isStaff;

  final Set<String> _approvedArrears = {};
  bool isArrearsApproved(String id) => _approvedArrears.contains(id);
  void approveArrearsReport(String id) {
    _approvedArrears.add(id);
    notifyListeners();
  }

  bool loginWithCredentials({required String username, required String password}) {
    final u = username.trim().toLowerCase();
    if (u == 'gm' || u == 'admin' || u.contains('general')) {
      _currentUser = UserModel.defaultGM;
    } else if (u == 'sm' || u == 'storemanager' || u.contains('store')) {
      _currentUser = UserModel.defaultSM;
    } else {
      _currentUser = UserModel.defaultStaff;
    }
    _isAuthenticated = true;
    _currentNavIndex = 0;
    notifyListeners();
    return true;
  }

  void switchUserRole(UserRole role) {
    if (role == UserRole.generalManager) {
      _currentUser = UserModel.defaultGM;
    } else if (role == UserRole.storeManager) {
      _currentUser = UserModel.defaultSM;
    } else {
      _currentUser = UserModel.defaultStaff;
    }
    notifyListeners();
  }

  void createTaskByGM({
    required String branch,
    required String title,
    required String details,
    required DateTime targetExecutionDate,
    required DateTime deadline,
    required String department,
    required String executionLevel,
    required String assignedTo,
    TaskPriority priority = TaskPriority.high,
  }) {
    final newTask = TaskItem(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      time: '${targetExecutionDate.hour.toString().padLeft(2, '0')}:${targetExecutionDate.minute.toString().padLeft(2, '0')} AM',
      priority: priority,
      status: TaskStatus.pending,
      description: details,
      branch: branch,
      department: department,
      createdDate: DateTime.now(),
      targetExecutionDate: targetExecutionDate,
      submitterName: assignedTo,
      category: department,
    );
    _tasks.insert(0, newTask);
    _unreadNotifications++;
    notifyListeners();
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Setters & Actions
  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  void setTaskSearchQuery(String query) {
    _taskSearchQuery = query;
    notifyListeners();
  }

  void setSubmittedSearchQuery(String query) {
    _submittedSearchQuery = query;
    notifyListeners();
  }

  void setSubmittedTabFilter(int filterIndex) {
    _submittedTabFilter = filterIndex;
    notifyListeners();
  }

  TaskItem? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void submitTask({
    required String taskId,
    required int skuCount,
    required bool discrepancyFound,
    String? discrepancyDetails,
    String? actionsTaken,
    List<String>? photos,
  }) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final now = DateTime(2024, 5, 15, 9, 45); // Aligned with the mockup May 15, 2024 09:45 AM
      task.status = TaskStatus.submitted;
      task.skuCount = skuCount;
      task.discrepancyFound = discrepancyFound;
      task.discrepancyDetails = discrepancyDetails;
      task.actionsTaken = actionsTaken;
      if (photos != null && photos.isNotEmpty) {
        task.photoUrls = List.from(photos);
      }
      task.submittedAt = now;
      notifyListeners();
    }
  }

  void addNewTask(TaskItem task) {
    _tasks.insert(0, task);
    notifyListeners();
  }
}
