import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsule_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_by_pagination_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_use_case.dart';

// Provider class that manages the state of capsules in the app.
// Handles fetching all capsules, fetching a capsule by ID, 
// paginated fetching, refreshing, loading, and error states.
class CapsuleProvider extends ChangeNotifier {
  final FetchCapsulesUseCase fetchCapsulesUseCase;
  final FetchCapsuleByIdUseCase fetchCapsuleByIdUseCase;
  final FetchCapsulesByPaginationUseCase fetchCapsulesByPaginationUseCase;

  CapsuleProvider({
    required this.fetchCapsulesUseCase,
    required this.fetchCapsuleByIdUseCase,
    required this.fetchCapsulesByPaginationUseCase,
  });

  List<CapsuleEntity> _capsules = []; // Stores all capsules
  List<CapsuleEntity> _paginatedCapsules = []; // Stores paginated capsules
  CapsuleEntity _capsule = CapsuleEntity.capsuledummy; // Stores a single capsule
  bool _isLoading = false; // Indicates loading state
  String? _error; // Stores error messages
  bool _isFetchingMore = false; // Indicates if more paginated data is being fetched
  bool _hasMore = true; // Tracks if more pages are available
  int offset = 0; // Offset for pagination
  int limit = 7; // Limit for pagination


  // Sets loading state and notifies listeners.
  void _setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  // Sets error state and notifies listeners.
  void _setError({required String? error}) {
    _error = error;
    notifyListeners();
  }

  // Sets fetching more state for pagination and notifies listeners.
  void _setFetchingMore({required bool fetching}) {
    _isFetchingMore = fetching;
    notifyListeners();
  }

  List<CapsuleEntity> get capsules => _capsules;
  CapsuleEntity? get capsule => _capsule;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  List<CapsuleEntity> get paginatedCapsules => _paginatedCapsules;

  
  // Fetches all capsules from the repository using the use case.
  // Updates loading and error states accordingly.
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

  // Fetches a single capsule by its id.
  // Updates loading and error states accordingly.
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

  // Fetches capsules in a paginated manner using offset and limit.
  // Prevents duplicate fetches and updates state variables accordingly.
  Future<void> fetchCapsulesByPagination() async {
    if (_isFetchingMore || !_hasMore) return;

    if (offset == 0) _setLoading(loading: true);
    _setFetchingMore(fetching: true);
    _setError(error: null);

    final paginatedCapsulesOrFailure =
        await fetchCapsulesByPaginationUseCase.call(
      offset: offset,
      limit: limit,
    );

    paginatedCapsulesOrFailure.fold(
      (failure) {
        _setError(error: failure.message);
      },
      (newCapsules) {
        if (newCapsules.isEmpty) {
          _hasMore = false; // No more capsules available
        } else {
          _paginatedCapsules.addAll(newCapsules);
          offset += paginatedCapsules.length; // Increment offset
        }
      },
    );

    _setFetchingMore(fetching: false);
    if (offset > 0) _setLoading(loading: false);
  }

  // Refreshes the paginated capsules list by clearing the current list
  // and fetching the first page again.
  Future<void> refreshCapsules() async {
    offset = 0;
    _hasMore = true;
    _paginatedCapsules.clear();
    _setLoading(loading: true);
    await fetchCapsulesByPagination();
    _setLoading(loading: false);
  }

  @override
  void dispose() {
    // Reset all state variables on dispose
    _capsules = [];
    _capsule = CapsuleEntity.capsuledummy;
    _isLoading = false;
    _error = null;
    _paginatedCapsules = [];
    _hasMore = true;
    _isFetchingMore = false;
    offset = 0;
    limit = 7;
    super.dispose();
  }
}
