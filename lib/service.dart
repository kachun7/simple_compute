import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyItem {
  final int id;
  final String title;

  MyItem(this.id, this.title);
}

class MyTask {
  /// Max duration for heavy work in milliseconds
  static const _maxDuration = 500;
  static final _random = Random();

  final MyItem item;

  MyTask(this.item);

  int get itemId => item.id;
  String get itemTitle => item.title;

  Future<int> doSomeHeavyWork() async {
    final randomNumber = _random.nextInt(MyTask._maxDuration) + 1;
    await Future.delayed(Duration(milliseconds: randomNumber));
    return randomNumber;
  }
}

class MyService {
  static const _numberOfItems = 100;

  final List<MyTask> tasks = <MyTask>[];
  final Map<int, ValueNotifier<bool>> taskNotifiers = <int, ValueNotifier<bool>>{};

  MyService() {
    // Create some dummy tasks
    for (var i = 0; i < MyService._numberOfItems; i++) {
      tasks.add(
        MyTask(
          MyItem(i, 'My item $i'),
        ),
      );
      taskNotifiers[i] = ValueNotifier<bool>(false);
    }
  }

  void dipose() {
    taskNotifiers.forEach((_, value) => value.dispose());
  }

  Future<void> runExpensiveTasks() async {
    int index = 0;
    while (index < tasks.length) {
      final task = tasks[index];
      if (!taskNotifiers.containsKey(task.itemId)) continue;
      taskNotifiers[task.itemId].value = true;
      await compute(MyService.doHeavySomeWork, task);

      if (!taskNotifiers.containsKey(task.itemId)) continue;
      taskNotifiers[task.itemId].value = false;
      index++;
    }
  }

  void removeAt(int index) {
    final task = tasks.removeAt(index);
    taskNotifiers.remove(task.itemId);
  }

  /// In order to make compute to work
  /// - the function must be static
  /// - the function must have argument
  static Future<void> doHeavySomeWork(MyTask task) => task.doSomeHeavyWork();
}
