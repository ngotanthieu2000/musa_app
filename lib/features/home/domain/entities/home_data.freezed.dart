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

HomeData _$HomeDataFromJson(Map<String, dynamic> json) {
  return _HomeData.fromJson(json);
}

/// @nodoc
mixin _$HomeData {
  String get userName => throw _privateConstructorUsedError;
  List<Task> get todayTasks => throw _privateConstructorUsedError;
  List<Goal> get goals => throw _privateConstructorUsedError;
  int get overallProgress => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  int get totalTasks => throw _privateConstructorUsedError;
  String? get reminder => throw _privateConstructorUsedError;
  Map<String, dynamic>? get healthData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get financeData => throw _privateConstructorUsedError;

  /// Serializes this HomeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
      {String userName,
      List<Task> todayTasks,
      List<Goal> goals,
      int overallProgress,
      int tasksCompleted,
      int totalTasks,
      String? reminder,
      Map<String, dynamic>? healthData,
      Map<String, dynamic>? financeData});
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
    Object? userName = null,
    Object? todayTasks = null,
    Object? goals = null,
    Object? overallProgress = null,
    Object? tasksCompleted = null,
    Object? totalTasks = null,
    Object? reminder = freezed,
    Object? healthData = freezed,
    Object? financeData = freezed,
  }) {
    return _then(_value.copyWith(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      todayTasks: null == todayTasks
          ? _value.todayTasks
          : todayTasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<Goal>,
      overallProgress: null == overallProgress
          ? _value.overallProgress
          : overallProgress // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalTasks: null == totalTasks
          ? _value.totalTasks
          : totalTasks // ignore: cast_nullable_to_non_nullable
              as int,
      reminder: freezed == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as String?,
      healthData: freezed == healthData
          ? _value.healthData
          : healthData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      financeData: freezed == financeData
          ? _value.financeData
          : financeData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      {String userName,
      List<Task> todayTasks,
      List<Goal> goals,
      int overallProgress,
      int tasksCompleted,
      int totalTasks,
      String? reminder,
      Map<String, dynamic>? healthData,
      Map<String, dynamic>? financeData});
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
    Object? userName = null,
    Object? todayTasks = null,
    Object? goals = null,
    Object? overallProgress = null,
    Object? tasksCompleted = null,
    Object? totalTasks = null,
    Object? reminder = freezed,
    Object? healthData = freezed,
    Object? financeData = freezed,
  }) {
    return _then(_$HomeDataImpl(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      todayTasks: null == todayTasks
          ? _value._todayTasks
          : todayTasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<Goal>,
      overallProgress: null == overallProgress
          ? _value.overallProgress
          : overallProgress // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalTasks: null == totalTasks
          ? _value.totalTasks
          : totalTasks // ignore: cast_nullable_to_non_nullable
              as int,
      reminder: freezed == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as String?,
      healthData: freezed == healthData
          ? _value._healthData
          : healthData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      financeData: freezed == financeData
          ? _value._financeData
          : financeData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeDataImpl implements _HomeData {
  const _$HomeDataImpl(
      {required this.userName,
      required final List<Task> todayTasks,
      required final List<Goal> goals,
      required this.overallProgress,
      required this.tasksCompleted,
      required this.totalTasks,
      this.reminder,
      final Map<String, dynamic>? healthData,
      final Map<String, dynamic>? financeData})
      : _todayTasks = todayTasks,
        _goals = goals,
        _healthData = healthData,
        _financeData = financeData;

  factory _$HomeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeDataImplFromJson(json);

  @override
  final String userName;
  final List<Task> _todayTasks;
  @override
  List<Task> get todayTasks {
    if (_todayTasks is EqualUnmodifiableListView) return _todayTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todayTasks);
  }

  final List<Goal> _goals;
  @override
  List<Goal> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  @override
  final int overallProgress;
  @override
  final int tasksCompleted;
  @override
  final int totalTasks;
  @override
  final String? reminder;
  final Map<String, dynamic>? _healthData;
  @override
  Map<String, dynamic>? get healthData {
    final value = _healthData;
    if (value == null) return null;
    if (_healthData is EqualUnmodifiableMapView) return _healthData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _financeData;
  @override
  Map<String, dynamic>? get financeData {
    final value = _financeData;
    if (value == null) return null;
    if (_financeData is EqualUnmodifiableMapView) return _financeData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'HomeData(userName: $userName, todayTasks: $todayTasks, goals: $goals, overallProgress: $overallProgress, tasksCompleted: $tasksCompleted, totalTasks: $totalTasks, reminder: $reminder, healthData: $healthData, financeData: $financeData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            const DeepCollectionEquality()
                .equals(other._todayTasks, _todayTasks) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.overallProgress, overallProgress) ||
                other.overallProgress == overallProgress) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            const DeepCollectionEquality()
                .equals(other._healthData, _healthData) &&
            const DeepCollectionEquality()
                .equals(other._financeData, _financeData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userName,
      const DeepCollectionEquality().hash(_todayTasks),
      const DeepCollectionEquality().hash(_goals),
      overallProgress,
      tasksCompleted,
      totalTasks,
      reminder,
      const DeepCollectionEquality().hash(_healthData),
      const DeepCollectionEquality().hash(_financeData));

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeDataImplToJson(
      this,
    );
  }
}

abstract class _HomeData implements HomeData {
  const factory _HomeData(
      {required final String userName,
      required final List<Task> todayTasks,
      required final List<Goal> goals,
      required final int overallProgress,
      required final int tasksCompleted,
      required final int totalTasks,
      final String? reminder,
      final Map<String, dynamic>? healthData,
      final Map<String, dynamic>? financeData}) = _$HomeDataImpl;

  factory _HomeData.fromJson(Map<String, dynamic> json) =
      _$HomeDataImpl.fromJson;

  @override
  String get userName;
  @override
  List<Task> get todayTasks;
  @override
  List<Goal> get goals;
  @override
  int get overallProgress;
  @override
  int get tasksCompleted;
  @override
  int get totalTasks;
  @override
  String? get reminder;
  @override
  Map<String, dynamic>? get healthData;
  @override
  Map<String, dynamic>? get financeData;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
