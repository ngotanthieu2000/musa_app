// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeData {
  String get welcomeMessage => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;
  int get completedTaskCount => throw _privateConstructorUsedError;
  String get userGreeting => throw _privateConstructorUsedError;
  List<String> get upcomingEvents => throw _privateConstructorUsedError;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDataCopyWith<HomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDataCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) then) =
      _$HomeDataCopyWithImpl<$Res, HomeData>;
  @useResult
  $Res call(
      {String welcomeMessage,
      int taskCount,
      int completedTaskCount,
      String userGreeting,
      List<String> upcomingEvents});
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res, $Val extends HomeData>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcomeMessage = null,
    Object? taskCount = null,
    Object? completedTaskCount = null,
    Object? userGreeting = null,
    Object? upcomingEvents = null,
  }) {
    return _then(_value.copyWith(
      welcomeMessage: null == welcomeMessage
          ? _value.welcomeMessage
          : welcomeMessage // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedTaskCount: null == completedTaskCount
          ? _value.completedTaskCount
          : completedTaskCount // ignore: cast_nullable_to_non_nullable
              as int,
      userGreeting: null == userGreeting
          ? _value.userGreeting
          : userGreeting // ignore: cast_nullable_to_non_nullable
              as String,
      upcomingEvents: null == upcomingEvents
          ? _value.upcomingEvents
          : upcomingEvents // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeDataImplCopyWith<$Res>
    implements $HomeDataCopyWith<$Res> {
  factory _$$HomeDataImplCopyWith(
          _$HomeDataImpl value, $Res Function(_$HomeDataImpl) then) =
      __$$HomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String welcomeMessage,
      int taskCount,
      int completedTaskCount,
      String userGreeting,
      List<String> upcomingEvents});
}

/// @nodoc
class __$$HomeDataImplCopyWithImpl<$Res>
    extends _$HomeDataCopyWithImpl<$Res, _$HomeDataImpl>
    implements _$$HomeDataImplCopyWith<$Res> {
  __$$HomeDataImplCopyWithImpl(
      _$HomeDataImpl _value, $Res Function(_$HomeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcomeMessage = null,
    Object? taskCount = null,
    Object? completedTaskCount = null,
    Object? userGreeting = null,
    Object? upcomingEvents = null,
  }) {
    return _then(_$HomeDataImpl(
      welcomeMessage: null == welcomeMessage
          ? _value.welcomeMessage
          : welcomeMessage // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedTaskCount: null == completedTaskCount
          ? _value.completedTaskCount
          : completedTaskCount // ignore: cast_nullable_to_non_nullable
              as int,
      userGreeting: null == userGreeting
          ? _value.userGreeting
          : userGreeting // ignore: cast_nullable_to_non_nullable
              as String,
      upcomingEvents: null == upcomingEvents
          ? _value._upcomingEvents
          : upcomingEvents // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$HomeDataImpl implements _HomeData {
  const _$HomeDataImpl(
      {required this.welcomeMessage,
      required this.taskCount,
      required this.completedTaskCount,
      required this.userGreeting,
      required final List<String> upcomingEvents})
      : _upcomingEvents = upcomingEvents;

  @override
  final String welcomeMessage;
  @override
  final int taskCount;
  @override
  final int completedTaskCount;
  @override
  final String userGreeting;
  final List<String> _upcomingEvents;
  @override
  List<String> get upcomingEvents {
    if (_upcomingEvents is EqualUnmodifiableListView) return _upcomingEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingEvents);
  }

  @override
  String toString() {
    return 'HomeData(welcomeMessage: $welcomeMessage, taskCount: $taskCount, completedTaskCount: $completedTaskCount, userGreeting: $userGreeting, upcomingEvents: $upcomingEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            (identical(other.welcomeMessage, welcomeMessage) ||
                other.welcomeMessage == welcomeMessage) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount) &&
            (identical(other.completedTaskCount, completedTaskCount) ||
                other.completedTaskCount == completedTaskCount) &&
            (identical(other.userGreeting, userGreeting) ||
                other.userGreeting == userGreeting) &&
            const DeepCollectionEquality()
                .equals(other._upcomingEvents, _upcomingEvents));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      welcomeMessage,
      taskCount,
      completedTaskCount,
      userGreeting,
      const DeepCollectionEquality().hash(_upcomingEvents));

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);
}

abstract class _HomeData implements HomeData {
  const factory _HomeData(
      {required final String welcomeMessage,
      required final int taskCount,
      required final int completedTaskCount,
      required final String userGreeting,
      required final List<String> upcomingEvents}) = _$HomeDataImpl;

  @override
  String get welcomeMessage;
  @override
  int get taskCount;
  @override
  int get completedTaskCount;
  @override
  String get userGreeting;
  @override
  List<String> get upcomingEvents;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
