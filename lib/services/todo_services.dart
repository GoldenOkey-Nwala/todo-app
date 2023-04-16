import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// All todo API will be here
class TodoServices {
  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateData(
    String id,
    Map body,
  ) async {
    // Update data on the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url); // converts url to uri
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> submitData(Map body) async {
    // Submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url); // converts url to uri
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 201;
  }

  static Future<void> showMyDialog(
    BuildContext context, {
    required Function() accept,
  }) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: accept,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
