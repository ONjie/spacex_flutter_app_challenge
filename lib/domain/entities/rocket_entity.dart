import 'package:equatable/equatable.dart';

class RocketEntity extends Equatable {
 const RocketEntity({
    required this.id,
    required this.active,
    required this.boosters,
    required this.company,
    required this.costPerLaunch,
    required this.country,
    required this.description,
    required this.diameterInFeet,
    required this.diameterInMeters,
    required this.firstFlight,
    required this.heightInFeet,
    required this.heightInMeters,
    required this.massInKg,
    required this.massInLb,
    required this.name,
    required this.stages,
    required this.successRate,
    required this.type
  });

  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int boosters;
  final int costPerLaunch;
  final int successRate;
  final double heightInFeet;
  final double heightInMeters;
  final double diameterInFeet;
  final double diameterInMeters;
  final int massInKg;
  final int massInLb;
  final DateTime firstFlight;
  final String description;
  final String company;
  final String country;
  
  @override
  List<Object?> get props => [
    id,
    name,
    type,
    active,
    stages,
    boosters,
    costPerLaunch,
    successRate,
    heightInFeet,
    heightInMeters,
    diameterInFeet,
    diameterInMeters,
    massInKg,
    massInLb,
    firstFlight,
    description,
    company,
    country
  ];
}
