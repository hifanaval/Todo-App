class ApiUrls {
  static const todos = 'https://jsonplaceholder.typicode.com/todos';
  static const users = 'https://jsonplaceholder.typicode.com/users';
  // For profile, we'll use a mock endpoint or extend users endpoint
  // In production, replace with your actual profile API endpoint
  static String profileByEmail(String email) => 'https://jsonplaceholder.typicode.com/users?email=$email';
  static String updateProfile(int id) => 'https://jsonplaceholder.typicode.com/users/$id';
}
