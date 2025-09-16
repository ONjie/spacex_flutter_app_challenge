import 'package:equatable/equatable.dart';
import 'package:spacex_flutter_app/domain/entities/landpad_entity.dart';

/// Data Model representing SpaceX Landpad
class LandpadModel extends Equatable {
  const LandpadModel({
    required this.id,
    required this.fullName,
    required this.details,
    required this.status,
  });

  final String id;
  final String fullName;
  final String status;
  final String details;


  /// Creates a LandpadModel from JSON Map
  factory LandpadModel.fromJson(Map<String, dynamic> json) => LandpadModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        details: json['details'] as String,
        status: json['status'] as String,
      );


   /// Converts LandpadModel to JSON Map
  Map<String, dynamic> toJson() => {
        "id": id,
        "details": details,
        "status": status,
        "full_name": fullName,
      };


   /// Converts LandpadModel to LandpadEntity
  /// This is used to pass data from the data layer to the domain layer
  LandpadEntity toEntity() => LandpadEntity(
        id: id,
        fullName: fullName,
        details: details,
        status: status,
      );

  @override
  List<Object?> get props => [id, fullName, status, details];
}
