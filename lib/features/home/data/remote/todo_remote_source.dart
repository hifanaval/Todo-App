import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class TodoRemoteSource {
  final http.Client client;

  TodoRemoteSource(this.client);

  Future<List<TodoDataModel>> fetchTodos({
    required int page,
    required int limit,
  }) async {
    final start = page * limit;
    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/todos?_start=$start&_limit=$limit',
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      return list.map((e) => TodoDataModel.fromJson(e)).toList();
    } else {
      throw Exception('API error');
    }
  }
}

