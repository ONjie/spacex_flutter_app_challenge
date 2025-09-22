import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rocket_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rockets_use_case.dart';
import '../../domain/entities/rocket_entity.dart';

// Provider class to manage state and logic for SpaceX rockets.
// Handles fetching all rockets, fetching a rocket by ID,
// loading, error states, and refreshing data.
class RocketProvider extends ChangeNotifier {
 
  final FetchRocketsUseCase fetchRocketsUseCase;
  final FetchRocketByIdUseCase fetchRocketByIdUseCase;

  // Constructor requiring the rocket use cases.
  RocketProvider({
    required this.fetchRocketsUseCase,
    required this.fetchRocketByIdUseCase,
  });

  List<RocketEntity> _rockets = []; // Stores all rockets
  RocketEntity _rocket = RocketEntity.rocketDummy; // Stores single rocket
  bool _isLoading = false; // Loading state
  String? _error; // Error message

  
  // Sets the loading state and notifies listeners.
  void _setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  // Sets the error message and notifies listeners.
  void _setError({required String? error}) {
    _error = error;
    notifyListeners();
  }

 
  List<RocketEntity> get rockets => _rockets;
  RocketEntity? get rocket => _rocket;
  bool get isLoading => _isLoading;
  String? get error => _error;

 

  // Fetches all rockets and updates loading and error states.
  Future<void> fetchRockets() async {
    _setLoading(loading: true);
    _setError(error: null);

    final rocketsOrFailure = await fetchRocketsUseCase.call();

    rocketsOrFailure.fold(
      (failure) => _setError(error: failure.message),
      (rockets) {
        _rockets = rockets;
        notifyListeners();
      },
    );

    _setLoading(loading: false);
  }

  // Fetches a single rocket by its id and updates state.
  Future<void> fetchRocketById({required String id}) async {
    _setLoading(loading: true);
    _setError(error: null);

    final rocketOrFailure = await fetchRocketByIdUseCase.call(id: id);

    rocketOrFailure.fold(
      (failure) => _setError(error: failure.message),
      (rocket) {
        _rocket = rocket;
        notifyListeners();
      },
    );

    _setLoading(loading: false);
  }

  // Clears any existing error message.
  void clearError() {
    _setError(error: null);
  }

  // Refreshes the rockets list by fetching all rockets again.
  void refreshRockets() async {
    await fetchRockets();
  }

  @override
  void dispose() {
    // Reset state variables when provider is disposed
    _rockets = [];
    _rocket = RocketEntity.rocketDummy;
    _isLoading = false;
    _error = null;
    super.dispose();
  }
}
