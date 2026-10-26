enum TaskPriority { high, medium, low }

enum TaskStatus { pending, submitted }

class TaskItem {
  final String id;
  final String title;
  final String time;
  final TaskPriority priority;
  TaskStatus status;
  final String description;
  final String branch;
  final String department;
  final DateTime createdDate;
  final DateTime targetExecutionDate;
  String submitterName;
  int? skuCount;
  bool? discrepancyFound;
  String? discrepancyDetails;
  String? actionsTaken;
  List<String> photoUrls;
  List<String> attachedFiles;
  DateTime? submittedAt;
  final String category;

  TaskItem({
    required this.id,
    required this.title,
    required this.time,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.description,
    this.branch = 'Kochi Central Hypermarket',
    String? department,
    DateTime? createdDate,
    DateTime? targetExecutionDate,
    this.submitterName = 'Juan Dela Cruz',
    this.skuCount,
    this.discrepancyFound,
    this.discrepancyDetails,
    this.actionsTaken,
    List<String>? photoUrls,
    List<String>? attachedFiles,
    this.submittedAt,
    this.category = 'General Operations',
  })  : department = department ?? category,
        createdDate = createdDate ?? DateTime(2024, 5, 14, 9, 0),
        targetExecutionDate = targetExecutionDate ?? DateTime(2024, 5, 15, 18, 0),
        photoUrls = photoUrls ?? [],
        attachedFiles = attachedFiles ?? [];

  TaskItem copyWith({
    String? id,
    String? title,
    String? time,
    TaskPriority? priority,
    TaskStatus? status,
    String? description,
    String? branch,
    String? department,
    DateTime? createdDate,
    DateTime? targetExecutionDate,
    String? submitterName,
    int? skuCount,
    bool? discrepancyFound,
    String? discrepancyDetails,
    String? actionsTaken,
    List<String>? photoUrls,
    List<String>? attachedFiles,
    DateTime? submittedAt,
    String? category,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      description: description ?? this.description,
      branch: branch ?? this.branch,
      department: department ?? this.department,
      createdDate: createdDate ?? this.createdDate,
      targetExecutionDate: targetExecutionDate ?? this.targetExecutionDate,
      submitterName: submitterName ?? this.submitterName,
      skuCount: skuCount ?? this.skuCount,
      discrepancyFound: discrepancyFound ?? this.discrepancyFound,
      discrepancyDetails: discrepancyDetails ?? this.discrepancyDetails,
      actionsTaken: actionsTaken ?? this.actionsTaken,
      photoUrls: photoUrls ?? List.from(this.photoUrls),
      attachedFiles: attachedFiles ?? List.from(this.attachedFiles),
      submittedAt: submittedAt ?? this.submittedAt,
      category: category ?? this.category,
    );
  }
}
