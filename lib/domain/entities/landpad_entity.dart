import 'package:equatable/equatable.dart';

class LandpadEntity extends Equatable {
  const LandpadEntity({
    required this.id,
    required this.fullName,
    required this.details,
    required this.status,
  });

  final String id;
  final String fullName;
  final String status;
  final String details;

  @override
  List<Object?> get props => [id, fullName, status, details];
}
