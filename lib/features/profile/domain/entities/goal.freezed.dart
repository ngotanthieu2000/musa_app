// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  GoalType get type => throw _privateConstructorUsedError;
  GoalCategory get category => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  int get targetValue => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  List<String>? get milestones => throw _privateConstructorUsedError;
  List<String>? get relatedTaskIds => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime deadline,
      GoalType type,
      GoalCategory category,
      int progress,
      int targetValue,
      String? unit,
      List<String>? milestones,
      List<String>? relatedTaskIds,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? deadline = null,
    Object? type = null,
    Object? category = null,
    Object? progress = null,
    Object? targetValue = null,
    Object? unit = freezed,
    Object? milestones = freezed,
    Object? relatedTaskIds = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GoalType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GoalCategory,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      milestones: freezed == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      relatedTaskIds: freezed == relatedTaskIds
          ? _value.relatedTaskIds
          : relatedTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime deadline,
      GoalType type,
      GoalCategory category,
      int progress,
      int targetValue,
      String? unit,
      List<String>? milestones,
      List<String>? relatedTaskIds,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? deadline = null,
    Object? type = null,
    Object? category = null,
    Object? progress = null,
    Object? targetValue = null,
    Object? unit = freezed,
    Object? milestones = freezed,
    Object? relatedTaskIds = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GoalType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GoalCategory,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      milestones: freezed == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      relatedTaskIds: freezed == relatedTaskIds
          ? _value._relatedTaskIds
          : relatedTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl implements _Goal {
  const _$GoalImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.deadline,
      required this.type,
      required this.category,
      this.progress = 0,
      this.targetValue = 100,
      this.unit,
      final List<String>? milestones,
      final List<String>? relatedTaskIds,
      this.completedAt,
      this.createdAt,
      this.updatedAt})
      : _milestones = milestones,
        _relatedTaskIds = relatedTaskIds;

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime deadline;
  @override
  final GoalType type;
  @override
  final GoalCategory category;
  @override
  @JsonKey()
  final int progress;
  @override
  @JsonKey()
  final int targetValue;
  @override
  final String? unit;
  final List<String>? _milestones;
  @override
  List<String>? get milestones {
    final value = _milestones;
    if (value == null) return null;
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _relatedTaskIds;
  @override
  List<String>? get relatedTaskIds {
    final value = _relatedTaskIds;
    if (value == null) return null;
    if (_relatedTaskIds is EqualUnmodifiableListView) return _relatedTaskIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Goal(id: $id, title: $title, description: $description, deadline: $deadline, type: $type, category: $category, progress: $progress, targetValue: $targetValue, unit: $unit, milestones: $milestones, relatedTaskIds: $relatedTaskIds, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            const DeepCollectionEquality()
                .equals(other._relatedTaskIds, _relatedTaskIds) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      deadline,
      type,
      category,
      progress,
      targetValue,
      unit,
      const DeepCollectionEquality().hash(_milestones),
      const DeepCollectionEquality().hash(_relatedTaskIds),
      completedAt,
      createdAt,
      updatedAt);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(
      this,
    );
  }
}

abstract class _Goal implements Goal {
  const factory _Goal(
      {required final String id,
      required final String title,
      final String? description,
      required final DateTime deadline,
      required final GoalType type,
      required final GoalCategory category,
      final int progress,
      final int targetValue,
      final String? unit,
      final List<String>? milestones,
      final List<String>? relatedTaskIds,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$GoalImpl;

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get deadline;
  @override
  GoalType get type;
  @override
  GoalCategory get category;
  @override
  int get progress;
  @override
  int get targetValue;
  @override
  String? get unit;
  @override
  List<String>? get milestones;
  @override
  List<String>? get relatedTaskIds;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
