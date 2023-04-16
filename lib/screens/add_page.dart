// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_services.dart';

import '../constants/spacer.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          heightSpace(20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Map get body {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }

  // Form handling for Update button
  Future<void> updateData() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    // Get the data from form
    final id = widget.todo!['_id'];

    final isSuccess = await TodoServices.updateData(id, body);
    // Show success or fail message based on status
    if (isSuccess) {
      Navigator.of(context).pop();
      showSuccessMessage(context, message: 'Post updated successfully.');
    } else if (titleController.text == '' ||
        descriptionController.text == '' ||
        titleController.text == '' && descriptionController.text == '') {
      showErrorMessage(context, message: 'Please complete all fields.');
    } else {
      showErrorMessage(context, message: 'Post update failed.');
    }
  }

  // Form Handling for Submit button
  Future<void> submitData() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    // Get the data from form

    final isSuccess = await TodoServices.submitData(body);

    if (isSuccess) {
      Navigator.of(context).pop();
      showSuccessMessage(context, message: 'Post created successfully.');
    } else if (titleController.text == '' ||
        descriptionController.text == '' ||
        titleController.text == '' && descriptionController.text == '') {
      showErrorMessage(context, message: 'Please complete all fields.');
    } else {
      showErrorMessage(context, message: 'Post creating failed.');
    }
  }
}
