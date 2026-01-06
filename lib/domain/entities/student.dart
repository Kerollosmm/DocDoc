// lib/domain/entities/student.dart
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String grade;
  final String phoneNumber;
  final String? address;
  final String? parentName;
  final String? parentPhone;
  final DateTime enrollmentDate;
  final bool isActive;

  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.phoneNumber,
    this.address,
    this.parentName,
    this.parentPhone,
    required this.enrollmentDate,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        grade,
        phoneNumber,
        address,
        parentName,
        parentPhone,
        enrollmentDate,
        isActive
      ];
}
