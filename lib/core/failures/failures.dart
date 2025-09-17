import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GraphQLFailure extends Failure{
  const GraphQLFailure({required super.message});

}

class InternetConnectionFailure extends Failure{
  const InternetConnectionFailure({required super.message});
  
}

class DataNotFoundFailure extends Failure{
  const DataNotFoundFailure({required super.message});
}