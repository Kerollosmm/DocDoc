import 'package:equatable/equatable.dart';

class ServantEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;

  const ServantEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, role];
}
