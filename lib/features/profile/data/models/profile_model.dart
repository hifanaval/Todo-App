class ProfileModel {
  final int? id;
  final String username;
  final String fullName;
  final String email;
  final String? profilePicturePath;
  final DateTime? dateOfBirth;

  ProfileModel({
    this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.profilePicturePath,
    this.dateOfBirth,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int?,
      username: json['username'] as String? ?? json['name']?.toString().split(' ').first.toLowerCase() ?? '',
      fullName: json['name'] as String? ?? json['username'] ?? '',
      email: json['email'] as String? ?? '',
      profilePicturePath: json['profilePicturePath'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': fullName,
      'email': email,
      'profilePicturePath': profilePicturePath,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }
}

