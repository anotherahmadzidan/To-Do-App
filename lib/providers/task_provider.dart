import 'package:flutter/material.dart';
import '../models/task.dart';

enum FilterOption { all, active, done }

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  FilterOption _filter = FilterOption.all;

  List<Task> get tasks {
    switch (_filter) {
      case FilterOption.active:
        return _tasks.where((task) => !task.isDone).toList();
      case FilterOption.done:
        return _tasks.where((task) => task.isDone).toList();
      case FilterOption.all:
      // ignore: unreachable_switch_default
      default:
        return _tasks;
    }
  }

  int get activeTaskCount => _tasks.where((task) => !task.isDone).length;

  FilterOption get filter => _filter;

  void addTask(String title) {
    if (title.trim().length < 3) return;
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void setFilter(FilterOption filterOption) {
    _filter = filterOption;
    notifyListeners();
  }
}
