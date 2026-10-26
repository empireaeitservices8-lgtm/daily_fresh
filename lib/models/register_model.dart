import 'package:flutter/material.dart';

// ----------------------------------------------------
// Module C: Daily Section Arrangement & Display (Module 8)
// ----------------------------------------------------
class DisplayManagementUpdate {
  final String id;
  final String department;
  final DateTime submissionDate;
  final String submitterName;
  final List<String> fileUrls;
  final List<String> fileNames;
  final String? notes;
  bool isArears;
  bool adminApprovalRequested;
  bool adminApproved;

  DisplayManagementUpdate({
    required this.id,
    required this.department,
    required this.submissionDate,
    this.submitterName = 'Juan Dela Cruz',
    List<String>? fileUrls,
    List<String>? fileNames,
    this.notes,
    this.isArears = false,
    this.adminApprovalRequested = false,
    this.adminApproved = false,
  })  : fileUrls = fileUrls ?? [],
        fileNames = fileNames ?? [];
}

// ----------------------------------------------------
// Module D: Sections Registers Updates (Module 9)
// ----------------------------------------------------
enum RegisterCategory {
  inventory,
  salesAndOperations,
  crm,
}

class RegisterTypeItem {
  final String id;
  final String name;
  final RegisterCategory category;

  const RegisterTypeItem({
    required this.id,
    required this.name,
    required this.category,
  });

  String get categoryName {
    switch (category) {
      case RegisterCategory.inventory:
        return 'Inventory';
      case RegisterCategory.salesAndOperations:
        return 'Sales and Operations';
      case RegisterCategory.crm:
        return 'CRM';
    }
  }

  Color get categoryColor {
    switch (category) {
      case RegisterCategory.inventory:
        return const Color(0xFF0284C7);
      case RegisterCategory.salesAndOperations:
        return const Color(0xFF16A34A);
      case RegisterCategory.crm:
        return const Color(0xFFD97706);
    }
  }
}

class AvailableRegisters {
  static const List<RegisterTypeItem> all = [
    // Inventory
    RegisterTypeItem(id: 'inward', name: 'Inward Register', category: RegisterCategory.inventory),
    RegisterTypeItem(id: 'outward', name: 'Outward Register', category: RegisterCategory.inventory),
    RegisterTypeItem(id: 'disposal', name: 'Disposal Register', category: RegisterCategory.inventory),
    RegisterTypeItem(id: 'prod_pack', name: 'Production or Packing Register', category: RegisterCategory.inventory),

    // Sales & Operations
    RegisterTypeItem(id: 'wastage', name: 'Wastage Register', category: RegisterCategory.salesAndOperations),
    RegisterTypeItem(id: 'fefo', name: 'Staffs FEFO Tracker Register', category: RegisterCategory.salesAndOperations),
    RegisterTypeItem(id: 'stock_out', name: 'Staffs Stock Out Monitor or Requisition Register', category: RegisterCategory.salesAndOperations),
    RegisterTypeItem(id: 'section_mon', name: 'Section Monitoring Checklist', category: RegisterCategory.salesAndOperations),

    // CRM
    RegisterTypeItem(id: 'complaint', name: 'Customer Complaint Register', category: RegisterCategory.crm),
  ];
}

class RegisterSubmission {
  final String id;
  final DateTime submissionDate;
  final String department;
  final List<String> selectedRegisterIds;
  final String submitterName;
  final List<String> fileUrls;
  final List<String> fileNames;
  final String? notes;

  RegisterSubmission({
    required this.id,
    required this.submissionDate,
    required this.department,
    required this.selectedRegisterIds,
    this.submitterName = 'Juan Dela Cruz',
    List<String>? fileUrls,
    List<String>? fileNames,
    this.notes,
  })  : fileUrls = fileUrls ?? [],
        fileNames = fileNames ?? [];

  List<RegisterTypeItem> get registers =>
      AvailableRegisters.all.where((r) => selectedRegisterIds.contains(r.id)).toList();
}
