import 'package:equatable/equatable.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';


/// Data Model representing SpaceX Capsule
class CapsuleModel extends Equatable {
  const CapsuleModel({
    required this.id,
    required this.reuseCount,
    required this.status,
    required this.type,
  });

  final String id;
  final int reuseCount;
  final String status;
  final String type;


  /// Creates a CapsuleModel from JSON Map
  factory CapsuleModel.fromJson(Map<String, dynamic> json) => CapsuleModel(
        id: json['id'] as String,
        reuseCount: (json['reuse_count'] as num).toInt(),
        status: json['status'] as String,
        type: json['type'] as String,
      );


   /// Converts CapsuleModel to JSON Map
  Map<String, dynamic> toJson() =>
      {"id": id, "reuse_count": reuseCount, "status": status, "type": type};


  /// Converts CapsuleModel to CapsuleEntity
  /// This is used to pass data from the data layer to the domain layer
  CapsuleEntity toEntity() => CapsuleEntity(
        id: id,
        reuseCount: reuseCount,
        status: status,
        type: type,
      );

  @override
  List<Object?> get props => [id, reuseCount, status, type];
}
