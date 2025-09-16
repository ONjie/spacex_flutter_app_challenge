import 'package:equatable/equatable.dart';

class CapsuleEntity extends Equatable {
  const CapsuleEntity({
    required this.id,
    required this.reuseCount,
    required this.status,
    required this.type,
  });

  final String id;
  final int reuseCount;
  final String status;
  final String type;

  @override
  List<Object?> get props => [id, reuseCount, status, type];
}
