import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  bool isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final url = Uri.https(
        'todo-41b26-default-rtdb.asia-southeast1.firebasedatabase.app',
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

      //取ってきたデータをローカルに保存
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Todo> loadedItems = [];
      for (final todo in listData.entries) {
        loadedItems.add(
          Todo(
            id: todo.key,
            title: todo.value['title'],
          ),
        );
      }
      setState(() {
        todos = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = 'Failed to load data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onDismissed: (direction) {},
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
