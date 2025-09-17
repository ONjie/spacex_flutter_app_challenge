import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rocket_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rockets_use_case.dart';

import '../../domain/entities/rocket_entity.dart';

// TODO: Implement RocketProvider
// This is a placeholder for the rocket state management
// You need to implement:
// 1. Rocket data models
// 2. GraphQL queries for rockets
// 3. Repository pattern for data fetching
// 4. State management for rockets list, loading, error states

class RocketProvider extends ChangeNotifier {
  final FetchRocketsUseCase fetchRocketsUseCase;
  final FetchRocketByIdUseCase fetchRocketByIdUseCase;

  RocketProvider({
    required this.fetchRocketsUseCase,
    required this.fetchRocketByIdUseCase,
  });

  // TODO: Add rocket-related state variables
  List<RocketEntity> _rockets = [];
  RocketEntity? _rocket;
  bool _isLoading = false;
  String? _error;

  //TODO: Add setters
  void _setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError({required String? error}) {
    _error = error;
    notifyListeners();
  }

  // TODO: Add getters
  List<RocketEntity> get rockets => _rockets;
  RocketEntity? get rocket => _rocket;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // TODO: Add methods
  Future<void> fetchRockets() async {
    _setLoading(loading: true);
    _setError(error: null);

    final rocketsOrFailure = await fetchRocketsUseCase.call();

    rocketsOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (rockets) {
        _rockets = rockets;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  Future<void> fetchRocketById({required String id}) async {
    _setLoading(loading: true);
    _setError(error: null);

    final rocketOrFailure = await fetchRocketByIdUseCase.call(id: id);

    rocketOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (rocket) {
        _rocket = rocket;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  void clearError() {
    _setError(error: null);
  }

  void refreshRockets() async {
    await fetchRockets();
  }

  @override
  void dispose() {
    _rockets = [];
    _rocket = null;
    _isLoading = false;
    _error = null;
    super.dispose();
  }
}
