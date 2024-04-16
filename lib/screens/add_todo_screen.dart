import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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
    final _formKey = GlobalKey<FormState>();
    List<Todo> todos = ref.watch(todolistProvider);
    String? _enteredTitle = '';
    bool isSending = false;
    var url = Uri.https(
        'todo-5933a-default-rtdb.asia-southeast1.firebasedatabase.app',
        'todo-list.json');

    void _addTodo() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          isSending = true;
        });
        final response = await http.post(
          url,
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode({
            'title': _enteredTitle,
          }),
        );
        if (context.mounted) {
          setState(() {
            isSending = false;
          });
          todos = [
            ...todos,
            Todo(
              id: json.decode(response.body)['name'],
              title: _enteredTitle!,
            ),
          ];
          Navigator.of(context).pop();
        }
      }
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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 50 ||
                        value.trim().isEmpty) {
                      return 'must be between 1 and 50 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredTitle = value!;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: _addTodo,
                      child: isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
