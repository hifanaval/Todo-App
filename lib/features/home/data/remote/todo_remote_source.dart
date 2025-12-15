import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/todo_model.dart';

class TodoRemoteSource {
  final http.Client client;
  final Connectivity _connectivity = Connectivity();

  TodoRemoteSource(this.client);

  Future<bool> _checkNetworkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
      debugPrint('🔵 [TodoRemoteSource] Network connectivity: $isConnected');
      return isConnected;
    } catch (e, stackTrace) {
      debugPrint('❌ [TodoRemoteSource] Error checking connectivity: $e');
      debugPrint('❌ [TodoRemoteSource] Stack trace: $stackTrace');
      return false;
    }
  }

  Future<List<TodoDataModel>> fetchTodos({
    required int page,
    required int limit,
  }) async {
    
    // Check network connectivity first
    final hasNetwork = await _checkNetworkConnectivity();
    
    if (!hasNetwork) {
      throw NetworkException('No network connection');
    }

    final start = page * limit;
    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/todos?_start=$start&_limit=$limit',
    );

    try {
      debugPrint('🔵 [TodoRemoteSource] Making HTTP GET request to: $url');
      
      // Add headers to avoid 403 errors (some APIs require User-Agent)
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'ToDoApp/1.0',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('TodoRemoteSource: Request timeout');
          throw NetworkException('Request timeout. Please check your connection.');
        },
      );

      debugPrint('🔵 [TodoRemoteSource] Response status code: ${response.statusCode}');
      debugPrint('🔵 [TodoRemoteSource] Response body length: ${response.body.length}');
      if (response.body.length > 200) {
        debugPrint('🔵 [TodoRemoteSource] Response body (first 200 chars): ${response.body.substring(0, 200)}');
      } else {
        debugPrint('🔵 [TodoRemoteSource] Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        debugPrint('✅ [TodoRemoteSource] Status 200 - Parsing response...');
        final List list = json.decode(response.body);
        final todos = list.map((e) => TodoDataModel.fromJson(e)).toList();
        debugPrint('✅ [TodoRemoteSource] Successfully fetched ${todos.length} todos');
        return todos;
      } else if (response.statusCode == 403) {
        debugPrint('❌ [TodoRemoteSource] 403 Forbidden error. Response body: ${response.body}');
        throw ApiException('Access forbidden (403). The API may be rate-limiting requests. Please try again later.');
      } else {
        debugPrint('❌ [TodoRemoteSource] API error with status code: ${response.statusCode}');
        debugPrint('❌ [TodoRemoteSource] Response body: ${response.body}');
        throw ApiException('API error: ${response.statusCode}. ${response.statusCode == 404 ? "Resource not found." : "No data found."}');
      }
    } on NetworkException catch (e) {
      debugPrint('❌ [TodoRemoteSource] NetworkException caught: ${e.message}');
      rethrow;
    } on ApiException catch (e) {
      debugPrint('❌ [TodoRemoteSource] ApiException caught: ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ [TodoRemoteSource] Unexpected error: $e');
      debugPrint('❌ [TodoRemoteSource] Stack trace: $stackTrace');
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup')) {
        throw NetworkException('No network connection');
      }
      throw ApiException('Failed to fetch data. Please try again.');
    }
  }
}

// Custom exception classes
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

