import 'package:flutter/material.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/widgets/todo_list.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddTodoScreen()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TodoList(),
    );
  }
}
