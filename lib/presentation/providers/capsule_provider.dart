import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsule_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_use_case.dart';

// TODO: Implement CapsuleProvider
// This is a placeholder for the capsule state management
// You need to implement:
// 1. Capsule data models
// 2. GraphQL queries for capsules
// 3. Repository pattern for data fetching
// 4. State management for capsules list, loading, error states

class CapsuleProvider extends ChangeNotifier {
  final FetchCapsulesUseCase fetchCapsulesUseCase;
  final FetchCapsuleByIdUseCase fetchCapsuleByIdUseCase;

  CapsuleProvider({
    required this.fetchCapsulesUseCase,
    required this.fetchCapsuleByIdUseCase,
  });

  // TODO: Add capsule-related state variables
  List<CapsuleEntity> _capsules = [];
  CapsuleEntity? _capsule;
  bool _isLoading = false;
  String? _error;

  // TODO: Add setters
  void _setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError({required String? error}) {
    _error = error;
    notifyListeners();
  }

  // TODO: Add getters
  List<CapsuleEntity> get capsules => _capsules;
  CapsuleEntity? get capsule => _capsule;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // TODO: Add methods
  Future<void> fetchCapsules() async {
    _setLoading(loading: true);
    _setError(error: null);

    final capsulesOrFailure = await fetchCapsulesUseCase.call();

    capsulesOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (capsules) {
        _capsules = capsules;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  Future<void> fetchCapsuleById({required String id}) async {
    _setLoading(loading: true);
    _setError(error: null);

    final capsuleOrFailure = await fetchCapsuleByIdUseCase.call(id: id);

    capsuleOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (capsule) {
        _capsule = capsule;
        notifyListeners();
      },
    );
    _setLoading(loading: false);
  }

  void clearError() {
    _setError(error: null);
  }

  void refreshCapsules() {
    fetchCapsules();
  }

  @override
  void dispose() {
    _capsules = [];
    _capsule = null;
    _isLoading = false;
    _error = null;
    super.dispose();
  }
}
