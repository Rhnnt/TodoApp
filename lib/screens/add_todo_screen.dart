import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  @override
  Widget build(BuildContext context) {
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
