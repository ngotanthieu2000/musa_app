import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? phoneNumber;
  final String? bio;
  final int? completionPercentage;
  final Preferences? preferences;
  final NotificationSettings? notificationSettings;
  final HealthData? healthData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    this.name,
    this.email,
    this.avatar,
    this.phoneNumber,
    this.bio,
    this.completionPercentage,
    this.preferences,
    this.notificationSettings,
    this.healthData,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? bio,
    int? completionPercentage,
    Preferences? preferences,
    NotificationSettings? notificationSettings,
    HealthData? healthData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      preferences: preferences ?? this.preferences,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      healthData: healthData ?? this.healthData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatar,
        phoneNumber,
        bio,
        completionPercentage,
        preferences,
        notificationSettings,
        healthData,
        createdAt,
        updatedAt,
      ];
}

class Location extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  const Location({
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  @override
  List<Object?> get props => [street, city, state, postalCode, country];

  Location copyWith({
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return Location(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}

class Preferences extends Equatable {
  final String? language;
  final bool? darkMode;
  final bool? receiveEmails;
  final bool? receiveAppUpdates;
  final List<String>? interests;
  final WorkingHours? workingHours;
  final QuietHours? quietHours;
  final Privacy? privacy;

  const Preferences({
    this.language,
    this.darkMode,
    this.receiveEmails,
    this.receiveAppUpdates,
    this.interests,
    this.workingHours,
    this.quietHours,
    this.privacy,
  });

  @override
  List<Object?> get props => [
        language,
        darkMode,
        receiveEmails,
        receiveAppUpdates,
        interests,
        workingHours,
        quietHours,
        privacy,
      ];

  Preferences copyWith({
    String? language,
    bool? darkMode,
    bool? receiveEmails,
    bool? receiveAppUpdates,
    List<String>? interests,
    WorkingHours? workingHours,
    QuietHours? quietHours,
    Privacy? privacy,
  }) {
    return Preferences(
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      receiveEmails: receiveEmails ?? this.receiveEmails,
      receiveAppUpdates: receiveAppUpdates ?? this.receiveAppUpdates,
      interests: interests ?? this.interests,
      workingHours: workingHours ?? this.workingHours,
      quietHours: quietHours ?? this.quietHours,
      privacy: privacy ?? this.privacy,
    );
  }
}

class WorkingHours extends Equatable {
  final String? start;
  final String? end;
  final List<int>? workDays;
  final bool? enabled;

  const WorkingHours({
    this.start,
    this.end,
    this.workDays,
    this.enabled,
  });

  @override
  List<Object?> get props => [start, end, workDays, enabled];

  WorkingHours copyWith({
    String? start,
    String? end,
    List<int>? workDays,
    bool? enabled,
  }) {
    return WorkingHours(
      start: start ?? this.start,
      end: end ?? this.end,
      workDays: workDays ?? this.workDays,
      enabled: enabled ?? this.enabled,
    );
  }
}

class Privacy extends Equatable {
  final bool? showEmail;
  final bool? showPhone;
  final bool? shareActivity;

  const Privacy({
    this.showEmail,
    this.showPhone,
    this.shareActivity,
  });

  @override
  List<Object?> get props => [showEmail, showPhone, shareActivity];

  Privacy copyWith({
    bool? showEmail,
    bool? showPhone,
    bool? shareActivity,
  }) {
    return Privacy(
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      shareActivity: shareActivity ?? this.shareActivity,
    );
  }
}

class NotificationSettings extends Equatable {
  final bool? pushEnabled;
  final bool? emailEnabled;
  final List<String>? categories;
  final QuietHours? quietHours;

  const NotificationSettings({
    this.pushEnabled,
    this.emailEnabled,
    this.categories,
    this.quietHours,
  });

  @override
  List<Object?> get props => [pushEnabled, emailEnabled, categories, quietHours];

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    List<String>? categories,
    QuietHours? quietHours,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      categories: categories ?? this.categories,
      quietHours: quietHours ?? this.quietHours,
    );
  }
}

class QuietHours extends Equatable {
  final String? start;
  final String? end;
  final bool? enabled;

  const QuietHours({
    this.start,
    this.end,
    this.enabled,
  });

  @override
  List<Object?> get props => [start, end, enabled];

  QuietHours copyWith({
    String? start,
    String? end,
    bool? enabled,
  }) {
    return QuietHours(
      start: start ?? this.start,
      end: end ?? this.end,
      enabled: enabled ?? this.enabled,
    );
  }
}

class HealthData extends Equatable {
  final double? height;
  final double? weight;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? medications;

  const HealthData({
    this.height,
    this.weight,
    this.bloodType,
    this.allergies,
    this.medications,
  });

  @override
  List<Object?> get props => [height, weight, bloodType, allergies, medications];

  HealthData copyWith({
    double? height,
    double? weight,
    String? bloodType,
    List<String>? allergies,
    List<String>? medications,
  }) {
    return HealthData(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
    );
  }
}

class ProfileCompletion extends Equatable {
  final double? completionRate;
  final List<String>? missingFields;

  const ProfileCompletion({
    this.completionRate,
    this.missingFields,
  });

  @override
  List<Object?> get props => [completionRate, missingFields];

  ProfileCompletion copyWith({
    double? completionRate,
    List<String>? missingFields,
  }) {
    return ProfileCompletion(
      completionRate: completionRate ?? this.completionRate,
      missingFields: missingFields ?? this.missingFields,
    );
  }
} 