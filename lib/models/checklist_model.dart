import 'package:flutter/material.dart';

enum ChecklistStatus {
  all,
  pending,
  completed,
  arears,
}

enum ChecklistAnswer {
  yes,
  no,
  na,
}

class ChecklistSubItem {
  final String id;
  final String title;
  bool isCompleted;
  ChecklistAnswer? answer;

  ChecklistSubItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.answer,
  });
}

class ChecklistItem {
  final String id;
  final String title;
  final String section;
  final String dueTime;
  final String? description;
  ChecklistStatus status;
  final String? notes;
  final List<ChecklistSubItem> subItems;
  DateTime? submittedAt;
  List<String> photos;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.section,
    required this.dueTime,
    this.description,
    required this.status,
    this.notes,
    List<ChecklistSubItem>? subItems,
    this.submittedAt,
    List<String>? photos,
  })  : subItems = subItems ?? [],
        photos = photos ?? [];

  int get completedSubItemCount =>
      subItems.where((i) => i.isCompleted || i.answer == ChecklistAnswer.yes).length;

  int get totalSubItemCount => subItems.length;

  double get progress =>
      totalSubItemCount > 0 ? completedSubItemCount / totalSubItemCount : 0.0;

  Color get statusTextColor {
    switch (status) {
      case ChecklistStatus.completed:
        return const Color(0xFF16A34A);
      case ChecklistStatus.pending:
        return const Color(0xFFF97316);
      case ChecklistStatus.arears:
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case ChecklistStatus.completed:
        return const Color(0xFFE8F8F0);
      case ChecklistStatus.pending:
        return const Color(0xFFFFF7ED);
      case ChecklistStatus.arears:
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  String get statusLabel {
    switch (status) {
      case ChecklistStatus.completed:
        return 'Completed';
      case ChecklistStatus.pending:
        return 'Pending';
      case ChecklistStatus.arears:
        return 'Arears';
      default:
        return 'All';
    }
  }
}
