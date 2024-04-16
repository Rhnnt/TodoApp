import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todolist_provider.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({super.key});

  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList> {
  late List<Todo> todos;
  bool isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    todos = ref.read(todolistProvider);
    _loadTodos();
  }

  void _loadTodos() async {
    final url = Uri.https(
        'todo-5933a-default-rtdb.asia-southeast1.firebasedatabase.app',
        'todo-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          isLoading = false;
        });
        throw Exception();
      } else if (response.body == 'null') {
        setState(() {
          isLoading = false;
        });
        return;
      }

      //取ってきたデータをriverpodで保存
      final Map<String, dynamic> listData = json.decode(response.body);
      for (final todo in listData.entries) {
        todos = [...todos, Todo(id: todo.key, title: todo.value['title'])];
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = 'Failed to load data. Please try again.';
      });
    }
  }

  void _deleteTodo(Todo todo) async {
    final index = todos.indexOf(todo);
    todos = [...todos.sublist(0, index), ...todos.sublist(index + 1)];
    final url = Uri.https(
        'todo-5933a-default-rtdb.asia-southeast1.firebasedatabase.app',
        'todo-list/${todo.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        todos.insert(index, todo);
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete an item.')));
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted an item.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    todos = ref.watch(todolistProvider);

    Widget content = Center(
      child: Text(_error != null ? _error! : 'No item added yet.'),
    );

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (todos.isNotEmpty) {
      content = ListView.builder(
        itemCount: todos.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(todos[index].id),
            onDismissed: (direction) {
              _deleteTodo(todos[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: ListTile(
                title: Text(todos[index].title),
              ),
            ),
          );
        },
      );
    }

    return content;
  }
}
