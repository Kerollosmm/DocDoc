import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String grade;
  final String phoneNumber;
  final String? address;

  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, grade, phoneNumber, address];
}
