import 'package:equatable/equatable.dart';

class LaunchpadEntity extends Equatable {
  const LaunchpadEntity({
    required this.id,
    required this.details,
    required this.name,
    required this.status,
    required this.wikipedia
  });

  final String id;
  final String details;
  final String name;
  final String status;
  final String wikipedia;

  @override
  List<Object?> get props => [id, details, name, status, wikipedia];
}
