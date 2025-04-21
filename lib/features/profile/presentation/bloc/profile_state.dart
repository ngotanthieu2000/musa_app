part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded({required this.profile});
  
  // Getter cho user, sử dụng profile
  Profile get user => profile;
  
  // Tính phần trăm hoàn thành hồ sơ
  double get completionPercentage => profile.completionPercentage?.toDouble() ?? 0.0;
  
  // Lấy danh sách các trường còn thiếu
  List<String> get missingFields {
    final List<String> fields = [];
    
    if (profile.name == null || profile.name!.isEmpty) {
      fields.add('Họ tên');
    }
    
    if (profile.avatar == null) {
      fields.add('Ảnh đại diện');
    }
    
    if (profile.phoneNumber == null || profile.phoneNumber!.isEmpty) {
      fields.add('Số điện thoại');
    }
    
    if (profile.bio == null || profile.bio!.isEmpty) {
      fields.add('Giới thiệu');
    }
    
    return fields;
  }

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileActionSuccess extends ProfileState {
  final String message;

  const ProfileActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
} 