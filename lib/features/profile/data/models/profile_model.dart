import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required String id,
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? bio,
    int? completionPercentage,
    PreferencesModel? preferences,
    NotificationSettingsModel? notificationSettings,
    HealthDataModel? healthData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          avatar: avatar,
          phoneNumber: phoneNumber,
          bio: bio,
          completionPercentage: completionPercentage,
          preferences: preferences,
          notificationSettings: notificationSettings,
          healthData: healthData,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      phoneNumber: json['phone_number'],
      bio: json['bio'],
      completionPercentage: json['completion_percentage'],
      preferences: json['preferences'] != null
          ? PreferencesModel.fromJson(json['preferences'])
          : null,
      notificationSettings: json['notification_settings'] != null
          ? NotificationSettingsModel.fromJson(json['notification_settings'])
          : null,
      healthData: json['health_data'] != null
          ? HealthDataModel.fromJson(json['health_data'])
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(), // Mặc định là thời gian hiện tại nếu không có
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone_number': phoneNumber,
      'bio': bio,
      'completion_percentage': completionPercentage,
      'preferences': preferences != null
          ? (preferences as PreferencesModel).toJson()
          : null,
      'notification_settings': notificationSettings != null
          ? (notificationSettings as NotificationSettingsModel).toJson()
          : null,
      'health_data': healthData != null
          ? (healthData as HealthDataModel).toJson()
          : null,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class LocationModel extends Location {
  const LocationModel({
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) : super(
          street: street,
          city: city,
          state: state,
          postalCode: postalCode,
          country: country,
        );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
    };
  }
}

class PreferencesModel extends Preferences {
  const PreferencesModel({
    String? language,
    bool? darkMode,
    bool? receiveEmails,
    bool? receiveAppUpdates,
    List<String>? interests,
    WorkingHoursModel? workingHours,
    QuietHoursModel? quietHours,
    PrivacyModel? privacy,
  }) : super(
          language: language,
          darkMode: darkMode,
          receiveEmails: receiveEmails,
          receiveAppUpdates: receiveAppUpdates,
          interests: interests,
          workingHours: workingHours,
          quietHours: quietHours,
          privacy: privacy,
        );

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      language: json['language'],
      darkMode: json['dark_mode'],
      receiveEmails: json['receive_emails'],
      receiveAppUpdates: json['receive_app_updates'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : null,
      workingHours: json['working_hours'] != null
          ? WorkingHoursModel.fromJson(json['working_hours'])
          : null,
      quietHours: json['quiet_hours'] != null
          ? QuietHoursModel.fromJson(json['quiet_hours'])
          : null,
      privacy: json['privacy'] != null
          ? PrivacyModel.fromJson(json['privacy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'dark_mode': darkMode,
      'receive_emails': receiveEmails,
      'receive_app_updates': receiveAppUpdates,
      'interests': interests,
      'working_hours': workingHours != null
          ? (workingHours as WorkingHoursModel).toJson()
          : null,
      'quiet_hours': quietHours != null
          ? (quietHours as QuietHoursModel).toJson()
          : null,
      'privacy': privacy != null
          ? (privacy as PrivacyModel).toJson()
          : null,
    };
  }
}

class WorkingHoursModel extends WorkingHours {
  const WorkingHoursModel({
    String? start,
    String? end,
    List<int>? workDays,
    bool? enabled,
  }) : super(
          start: start,
          end: end,
          workDays: workDays,
          enabled: enabled,
        );

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      start: json['start'],
      end: json['end'],
      workDays: json['work_days'] != null
          ? List<int>.from(json['work_days'])
          : null,
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'work_days': workDays,
      'enabled': enabled,
    };
  }
}

class PrivacyModel extends Privacy {
  const PrivacyModel({
    bool? showEmail,
    bool? showPhone,
    bool? shareActivity,
  }) : super(
          showEmail: showEmail,
          showPhone: showPhone,
          shareActivity: shareActivity,
        );

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      showEmail: json['show_email'],
      showPhone: json['show_phone'],
      shareActivity: json['share_activity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_email': showEmail,
      'show_phone': showPhone,
      'share_activity': shareActivity,
    };
  }
}

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    bool? pushEnabled,
    bool? emailEnabled,
    List<String>? categories,
    QuietHoursModel? quietHours,
  }) : super(
          pushEnabled: pushEnabled,
          emailEnabled: emailEnabled,
          categories: categories,
          quietHours: quietHours,
        );

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      pushEnabled: json['push_enabled'],
      emailEnabled: json['email_enabled'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      quietHours: json['quiet_hours'] != null
          ? QuietHoursModel.fromJson(json['quiet_hours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_enabled': pushEnabled,
      'email_enabled': emailEnabled,
      'categories': categories,
      'quiet_hours': quietHours != null
          ? (quietHours as QuietHoursModel).toJson()
          : null,
    };
  }
}

class QuietHoursModel extends QuietHours {
  const QuietHoursModel({
    String? start,
    String? end,
    bool? enabled,
  }) : super(
          start: start,
          end: end,
          enabled: enabled,
        );

  factory QuietHoursModel.fromJson(Map<String, dynamic> json) {
    return QuietHoursModel(
      start: json['start'],
      end: json['end'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'enabled': enabled,
    };
  }
}

class HealthDataModel extends HealthData {
  const HealthDataModel({
    double? height,
    double? weight,
    String? bloodType,
    List<String>? allergies,
    List<String>? medications,
  }) : super(
          height: height,
          weight: weight,
          bloodType: bloodType,
          allergies: allergies,
          medications: medications,
        );

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      height: json['height'] != null ? json['height'].toDouble() : null,
      weight: json['weight'] != null ? json['weight'].toDouble() : null,
      bloodType: json['blood_type'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      medications: json['medications'] != null
          ? List<String>.from(json['medications'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'blood_type': bloodType,
      'allergies': allergies,
      'medications': medications,
    };
  }
}

class ProfileCompletionModel extends ProfileCompletion {
  const ProfileCompletionModel({
    double? completionRate,
    List<String>? missingFields,
  }) : super(
          completionRate: completionRate,
          missingFields: missingFields,
        );

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionModel(
      completionRate: json['completion_rate'] != null
          ? json['completion_rate'].toDouble()
          : null,
      missingFields: json['missing_fields'] != null
          ? List<String>.from(json['missing_fields'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completion_rate': completionRate,
      'missing_fields': missingFields,
    };
  }
} 