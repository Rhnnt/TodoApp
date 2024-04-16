import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/todo.dart';

class TodolistProvider extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }
}

final todolistProvider =
    NotifierProvider<TodolistProvider, List<Todo>>(() => TodolistProvider());
