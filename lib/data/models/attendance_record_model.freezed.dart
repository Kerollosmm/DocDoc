// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttendanceRecordModel _$AttendanceRecordModelFromJson(
    Map<String, dynamic> json) {
  return _AttendanceRecordModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceRecordModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get studentId => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(3)
  String get gradeId => throw _privateConstructorUsedError;
  @HiveField(4)
  AttendanceStatus get status => throw _privateConstructorUsedError;
  @HiveField(5)
  String get markedBy => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get markedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isConflict => throw _privateConstructorUsedError;

  /// Serializes this AttendanceRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceRecordModelCopyWith<AttendanceRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceRecordModelCopyWith<$Res> {
  factory $AttendanceRecordModelCopyWith(AttendanceRecordModel value,
          $Res Function(AttendanceRecordModel) then) =
      _$AttendanceRecordModelCopyWithImpl<$Res, AttendanceRecordModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String studentId,
      @HiveField(2) DateTime date,
      @HiveField(3) String gradeId,
      @HiveField(4) AttendanceStatus status,
      @HiveField(5) String markedBy,
      @HiveField(6) DateTime markedAt,
      @HiveField(7) bool isConflict});
}

/// @nodoc
class _$AttendanceRecordModelCopyWithImpl<$Res,
        $Val extends AttendanceRecordModel>
    implements $AttendanceRecordModelCopyWith<$Res> {
  _$AttendanceRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? gradeId = null,
    Object? status = null,
    Object? markedBy = null,
    Object? markedAt = null,
    Object? isConflict = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gradeId: null == gradeId
          ? _value.gradeId
          : gradeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      markedBy: null == markedBy
          ? _value.markedBy
          : markedBy // ignore: cast_nullable_to_non_nullable
              as String,
      markedAt: null == markedAt
          ? _value.markedAt
          : markedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isConflict: null == isConflict
          ? _value.isConflict
          : isConflict // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceRecordModelImplCopyWith<$Res>
    implements $AttendanceRecordModelCopyWith<$Res> {
  factory _$$AttendanceRecordModelImplCopyWith(
          _$AttendanceRecordModelImpl value,
          $Res Function(_$AttendanceRecordModelImpl) then) =
      __$$AttendanceRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String studentId,
      @HiveField(2) DateTime date,
      @HiveField(3) String gradeId,
      @HiveField(4) AttendanceStatus status,
      @HiveField(5) String markedBy,
      @HiveField(6) DateTime markedAt,
      @HiveField(7) bool isConflict});
}

/// @nodoc
class __$$AttendanceRecordModelImplCopyWithImpl<$Res>
    extends _$AttendanceRecordModelCopyWithImpl<$Res,
        _$AttendanceRecordModelImpl>
    implements _$$AttendanceRecordModelImplCopyWith<$Res> {
  __$$AttendanceRecordModelImplCopyWithImpl(_$AttendanceRecordModelImpl _value,
      $Res Function(_$AttendanceRecordModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? gradeId = null,
    Object? status = null,
    Object? markedBy = null,
    Object? markedAt = null,
    Object? isConflict = null,
  }) {
    return _then(_$AttendanceRecordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gradeId: null == gradeId
          ? _value.gradeId
          : gradeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      markedBy: null == markedBy
          ? _value.markedBy
          : markedBy // ignore: cast_nullable_to_non_nullable
              as String,
      markedAt: null == markedAt
          ? _value.markedAt
          : markedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isConflict: null == isConflict
          ? _value.isConflict
          : isConflict // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 2)
class _$AttendanceRecordModelImpl extends _AttendanceRecordModel {
  const _$AttendanceRecordModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.studentId,
      @HiveField(2) required this.date,
      @HiveField(3) required this.gradeId,
      @HiveField(4) required this.status,
      @HiveField(5) required this.markedBy,
      @HiveField(6) required this.markedAt,
      @HiveField(7) this.isConflict = false})
      : super._();

  factory _$AttendanceRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceRecordModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String studentId;
  @override
  @HiveField(2)
  final DateTime date;
  @override
  @HiveField(3)
  final String gradeId;
  @override
  @HiveField(4)
  final AttendanceStatus status;
  @override
  @HiveField(5)
  final String markedBy;
  @override
  @HiveField(6)
  final DateTime markedAt;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isConflict;

  @override
  String toString() {
    return 'AttendanceRecordModel(id: $id, studentId: $studentId, date: $date, gradeId: $gradeId, status: $status, markedBy: $markedBy, markedAt: $markedAt, isConflict: $isConflict)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.gradeId, gradeId) || other.gradeId == gradeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.markedBy, markedBy) ||
                other.markedBy == markedBy) &&
            (identical(other.markedAt, markedAt) ||
                other.markedAt == markedAt) &&
            (identical(other.isConflict, isConflict) ||
                other.isConflict == isConflict));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, studentId, date, gradeId,
      status, markedBy, markedAt, isConflict);

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceRecordModelImplCopyWith<_$AttendanceRecordModelImpl>
      get copyWith => __$$AttendanceRecordModelImplCopyWithImpl<
          _$AttendanceRecordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceRecordModelImplToJson(
      this,
    );
  }
}

abstract class _AttendanceRecordModel extends AttendanceRecordModel {
  const factory _AttendanceRecordModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String studentId,
      @HiveField(2) required final DateTime date,
      @HiveField(3) required final String gradeId,
      @HiveField(4) required final AttendanceStatus status,
      @HiveField(5) required final String markedBy,
      @HiveField(6) required final DateTime markedAt,
      @HiveField(7) final bool isConflict}) = _$AttendanceRecordModelImpl;
  const _AttendanceRecordModel._() : super._();

  factory _AttendanceRecordModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceRecordModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get studentId;
  @override
  @HiveField(2)
  DateTime get date;
  @override
  @HiveField(3)
  String get gradeId;
  @override
  @HiveField(4)
  AttendanceStatus get status;
  @override
  @HiveField(5)
  String get markedBy;
  @override
  @HiveField(6)
  DateTime get markedAt;
  @override
  @HiveField(7)
  bool get isConflict;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceRecordModelImplCopyWith<_$AttendanceRecordModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
