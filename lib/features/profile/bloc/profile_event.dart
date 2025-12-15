import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String email;

  const LoadProfile(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdateProfile extends ProfileEvent {
  final int profileId;
  final String? username;
  final XFile? profilePicture;
  final DateTime? dateOfBirth;

  const UpdateProfile({
    required this.profileId,
    this.username,
    this.profilePicture,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [profileId, username, profilePicture, dateOfBirth];
}

class ResetProfileState extends ProfileEvent {
  const ResetProfileState();
}

