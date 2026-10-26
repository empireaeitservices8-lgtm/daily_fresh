import 'package:flutter_test/flutter_test.dart';
import 'package:dayfresh_app/models/task_model.dart';
import 'package:dayfresh_app/providers/app_state.dart';

void main() {
  group('AppState Task Management Tests', () {
    test('Initial state matches mockup counts', () {
      final state = AppState();

      expect(state.totalTasksCount, 12);
      expect(state.pendingTasksCount, 5);
      expect(state.submittedTasksCount, 7);
      expect(state.progressPercentage, 58);
    });

    test('Submitting a task updates state and progress dynamically', () {
      final state = AppState();

      // Submit Stock Audit task
      state.submitTask(
        taskId: 'task-1',
        skuCount: 250,
        discrepancyFound: true,
        discrepancyDetails: '5 items with quantity mismatch',
        actionsTaken: 'Corrected quantities and informed team',
        photos: ['photo1.jpg', 'photo2.jpg'],
      );

      final task = state.getTaskById('task-1');
      expect(task, isNotNull);
      expect(task!.status, TaskStatus.submitted);
      expect(task.skuCount, 250);
      expect(task.discrepancyFound, true);

      // Pending should now be 4, submitted should be 8
      expect(state.pendingTasksCount, 4);
      expect(state.submittedTasksCount, 8);
      expect(state.progressPercentage, 67); // 8/12 = 66.67% -> 67%
    });

    test('Date selection updates correctly', () {
      final state = AppState();
      final newDate = DateTime(2024, 6, 1);
      state.setSelectedDate(newDate);
      expect(state.selectedDate, newDate);
    });

    test('Nav index changes correctly', () {
      final state = AppState();
      state.setNavIndex(1);
      expect(state.currentNavIndex, 1);
    });
  });
}
