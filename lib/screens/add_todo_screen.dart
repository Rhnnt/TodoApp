import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todolist_provider.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  const AddTodoScreen({super.key});

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  @override
  Widget build(BuildContext context) {
    List<Todo> todos = ref.watch(todolistProvider);
    String? _enteredTitle;

    void _addTodo() async {
      //riverpodで管理するtodosをローカル用の変数にして、それとは別にリモートの更新と読み込み、、？？？
      todos = [...todos, Todo(id: , title: _enteredTitle)];
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new todo',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Center(
        child: Form(
          child: Column(),
        ),
      ),
    );
  }
}
