// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_app/constants/spacer.dart';
import 'package:todo_app/services/todo_services.dart';

import '../utils/snackbar_helper.dart';
import '../widget/refresh_button.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListState();
}

class _TodoListState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Todo item',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  heightSpace(10),
                  RefreshButton(onPressed: fetchTodo),
                ],
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return TodoCard(
                  index: index,
                  item: item,
                  navigateToEditPage: navigateToEditPage,
                  deleteById: (id) => TodoServices.showMyDialog(
                    context,
                    accept: () => deleteById(id),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  // Edit page handling
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    fetchTodo();
  }

  // Add todo button handling
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    fetchTodo();
  }

  // Delete item from list
  Future<void> deleteById(String id) async {
    Navigator.of(context).pop();
    final isSuccess = await TodoServices.deleteById(id);

    if (isSuccess) {
      // Remove item from list
      final filtered = items.where((e) => e['_id'] != id).toList();
      setState(() {
        items = filtered;
      });

      showSuccessMessage(context, message: 'Item was deleted successfully.');
    } else {
      showErrorMessage(context,
          message:
              'Something went wrong, please check your internet connection.');
    }
  }

  // API Get all
  Future<void> fetchTodo() async {
    // setState(() {
    //   isLoading = true;
    // });
    final response = await TodoServices.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong.');
    }
    setState(() {
      isLoading = false;
    });
  }
}
