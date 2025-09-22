import 'package:equatable/equatable.dart';

class RocketEntity extends Equatable {
  const RocketEntity({
    required this.id,
    required this.active,
    required this.boosters,
    required this.costPerLaunch,
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
    required this.type,
    required this.numberOfEngines,
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
  final int numberOfEngines;

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
        numberOfEngines
      ];

  static RocketEntity rocketDummy = RocketEntity(
    id: 'id',
    active: false,
    boosters: 1,
    costPerLaunch: 30000,
    description: 'description',
    diameterInFeet: 50,
    diameterInMeters: 30,
    firstFlight: DateTime.now(),
    heightInFeet: 50,
    heightInMeters: 30,
    massInKg: 300,
    massInLb: 150,
    name: 'name',
    stages: 1,
    successRate: 90,
    type: 'type',
    numberOfEngines: 2,
  );
}
