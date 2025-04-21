part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final Map<String, dynamic> profile;

  const UpdateProfileEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UpdatePreferencesEvent extends ProfileEvent {
  final Map<String, dynamic> preferences;

  const UpdatePreferencesEvent({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

class UpdateNotificationSettingsEvent extends ProfileEvent {
  final Map<String, dynamic> settings;

  const UpdateNotificationSettingsEvent({required this.settings});

  @override
  List<Object> get props => [settings];
}

class UpdateHealthDataEvent extends ProfileEvent {
  final Map<String, dynamic> healthData;

  const UpdateHealthDataEvent({required this.healthData});

  @override
  List<Object> get props => [healthData];
}

class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword, 
    required this.newPassword
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
} 