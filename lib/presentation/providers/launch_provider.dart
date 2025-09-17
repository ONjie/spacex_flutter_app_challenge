import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launch_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_use_case.dart';

// TODO: Implement LaunchProvider
// This is a placeholder for the launch state management
// You need to implement:
// 1. Launch data models
// 2. GraphQL queries for launches
// 3. Repository pattern for data fetching
// 4. State management for launches list, loading, error states

class LaunchProvider extends ChangeNotifier {
  final FetchLaunchesUseCase fetchLaunchesUseCase;
  final FetchLaunchByIdUseCase fetchLaunchByIdUseCase;

  LaunchProvider({
    required this.fetchLaunchesUseCase,
    required this.fetchLaunchByIdUseCase,
  });
  // TODO: Add launch-related state variables
  List<LaunchEntity> _launches = [];
  LaunchEntity? _launch;
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
  List<LaunchEntity> get launches => _launches;
  LaunchEntity? get launch => _launch;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // TODO: Add methods
  Future<void> fetchLaunches() async {
    _setLoading(loading: true);
    _setError(error: null);

    final launchesOrFailure = await fetchLaunchesUseCase.call();

    launchesOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (launches) {
        _launches = launches;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  Future<void> fetchLaunchById({required String id}) async {
    _setLoading(loading: true);
    _setError(error: null);

    final launchOrFailure = await fetchLaunchByIdUseCase.call(id: id);

    launchOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (launch) {
        _launch = launch;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  void clearError() {
    _setError(error: null);
  }

  void refreshLaunches() async {
    await fetchLaunches();
  }

  @override
  void dispose() {
    _launches = [];
    _launch = null;
    _isLoading = false;
    _error = null;
    super.dispose();
  }
}
