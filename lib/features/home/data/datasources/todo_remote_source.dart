import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/todo_model.dart';
import '../../../../core/constants/api_urls.dart';

class TodoRemoteSource {
  Future<List<TodoDataModel>> fetchTodos({
    required int start,
    required int limit,
  }) async {
    final uri = Uri.parse(
      '${ApiUrls.todos}?_start=$start&_limit=$limit',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // Authorization not needed for this API
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TodoDataModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}

