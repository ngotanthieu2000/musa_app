// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isRepeating => throw _privateConstructorUsedError;
  String? get repeatFrequency => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime dueDate,
      TaskStatus status,
      TaskPriority priority,
      String? category,
      List<String>? tags,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isRepeating,
      String? repeatFrequency,
      String? assignedTo});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = null,
    Object? status = null,
    Object? priority = null,
    Object? category = freezed,
    Object? tags = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRepeating = null,
    Object? repeatFrequency = freezed,
    Object? assignedTo = freezed,
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
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
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
      isRepeating: null == isRepeating
          ? _value.isRepeating
          : isRepeating // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatFrequency: freezed == repeatFrequency
          ? _value.repeatFrequency
          : repeatFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime dueDate,
      TaskStatus status,
      TaskPriority priority,
      String? category,
      List<String>? tags,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isRepeating,
      String? repeatFrequency,
      String? assignedTo});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = null,
    Object? status = null,
    Object? priority = null,
    Object? category = freezed,
    Object? tags = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isRepeating = null,
    Object? repeatFrequency = freezed,
    Object? assignedTo = freezed,
  }) {
    return _then(_$TaskImpl(
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
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
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
      isRepeating: null == isRepeating
          ? _value.isRepeating
          : isRepeating // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatFrequency: freezed == repeatFrequency
          ? _value.repeatFrequency
          : repeatFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.dueDate,
      required this.status,
      required this.priority,
      this.category,
      final List<String>? tags,
      this.completedAt,
      this.createdAt,
      this.updatedAt,
      this.isRepeating = false,
      this.repeatFrequency,
      this.assignedTo})
      : _tags = tags;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime dueDate;
  @override
  final TaskStatus status;
  @override
  final TaskPriority priority;
  @override
  final String? category;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
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
  @JsonKey()
  final bool isRepeating;
  @override
  final String? repeatFrequency;
  @override
  final String? assignedTo;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, status: $status, priority: $priority, category: $category, tags: $tags, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, isRepeating: $isRepeating, repeatFrequency: $repeatFrequency, assignedTo: $assignedTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isRepeating, isRepeating) ||
                other.isRepeating == isRepeating) &&
            (identical(other.repeatFrequency, repeatFrequency) ||
                other.repeatFrequency == repeatFrequency) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      dueDate,
      status,
      priority,
      category,
      const DeepCollectionEquality().hash(_tags),
      completedAt,
      createdAt,
      updatedAt,
      isRepeating,
      repeatFrequency,
      assignedTo);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String title,
      final String? description,
      required final DateTime dueDate,
      required final TaskStatus status,
      required final TaskPriority priority,
      final String? category,
      final List<String>? tags,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isRepeating,
      final String? repeatFrequency,
      final String? assignedTo}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get dueDate;
  @override
  TaskStatus get status;
  @override
  TaskPriority get priority;
  @override
  String? get category;
  @override
  List<String>? get tags;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isRepeating;
  @override
  String? get repeatFrequency;
  @override
  String? get assignedTo;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
