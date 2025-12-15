/// Utility class for profile-related calculations and helpers
class ProfileUtils {
  /// Calculate profile completeness percentage
  /// Returns a value between 0 and 100
  static int calculateCompleteness({
    required String username,
    String? profilePicturePath,
    DateTime? dateOfBirth,
  }) {
    int completeness = 0;
    if (username.isNotEmpty) completeness += 33;
    if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
      completeness += 33;
    }
    if (dateOfBirth != null) completeness += 34;
    return completeness;
  }

  /// Format date of birth to YYYY-MM-DD format
  static String formatDateOfBirth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

