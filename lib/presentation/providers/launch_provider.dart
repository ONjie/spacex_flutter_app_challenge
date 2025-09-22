import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launch_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_by_pagination_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_use_case.dart';

// Provider class that manages state and logic for SpaceX launches.
// Handles fetching all launches, fetching a launch by ID, pagination,
// filtering, search, loading and error states.
class LaunchProvider extends ChangeNotifier {
  final FetchLaunchesUseCase fetchLaunchesUseCase;
  final FetchLaunchByIdUseCase fetchLaunchByIdUseCase;
  final FetchLaunchesByPaginationUseCase fetchLaunchesByPaginationUseCase;

  LaunchProvider({
    required this.fetchLaunchesUseCase,
    required this.fetchLaunchByIdUseCase,
    required this.fetchLaunchesByPaginationUseCase,
  });

 
  List<LaunchEntity> _launches = []; // All launches
  List<LaunchEntity> _paginatedLaunches = []; // Paginated launches
  List<LaunchEntity> _filteredLaunches = []; // Filtered or searched launches
  LaunchEntity _launch = LaunchEntity.dummyLaunch; // Single launch
  bool _isLoading = false; // Loading state
  String? _error; // Error message
  bool _isFetchingMore = false; // Pagination fetch state
  bool _hasMore = true; // Flag for more pages
  int offset = 0; // Pagination offset
  int limit = 4; // Pagination limit
  String _searchQuery = ''; // Current search query
  bool? _filterUpcoming; // Upcoming filter flag

  
  List<LaunchEntity> get launches => _launches;
  LaunchEntity? get launch => _launch;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  List<LaunchEntity> get paginatedLaunches => _paginatedLaunches;
  List<LaunchEntity> get filteredLaunches => _filteredLaunches;
  bool? get filterUpcoming => _filterUpcoming;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;

  
  void _setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError({required String? error}) {
    _error = error;
    notifyListeners();
  }

  void _setFetchingMore({required bool fetching}) {
    _isFetchingMore = fetching;
    notifyListeners();
  }


  
  // Sets the search query and applies filters.
  void setSearchQuery({required String query}) {
    _searchQuery = query;
    _applyFilters();
  }

  // Sets the upcoming filter and applies filters.
  void setFilter({required bool? upcoming}) {
    _filterUpcoming = upcoming;
    _applyFilters();
  }

  // Resets search and filter to default and applies filters.
  void resetFilters() {
    _searchQuery = '';
    _filterUpcoming = null;
    _applyFilters();
  }

  // Applies search and upcoming filters to launches.
  void _applyFilters() {
    if (_searchQuery.isEmpty && _filterUpcoming == null) {
      _filteredLaunches = [];
    } else {
      _filteredLaunches = _launches.where((l) {
        final matchesQuery = _searchQuery.isEmpty ||
            l.rocketName.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesUpcoming =
            _filterUpcoming == null || l.upcoming == _filterUpcoming;
        return matchesQuery && matchesUpcoming;
      }).toList();
    }
    notifyListeners();
  }
  
  // Fetches all launches and updates loading and error states.
  Future<void> fetchLaunches() async {
    _launches = [];
    _setLoading(loading: true);
    _setError(error: null);

    final launchesOrFailure = await fetchLaunchesUseCase.call();

    launchesOrFailure.fold(
      (failure) => _setError(error: failure.message),
      (launches) => _launches = launches,
    );

    _setLoading(loading: false);
  }

  // Fetches a single launch by ID and updates state.
  Future<void> fetchLaunchById({required String id}) async {
    _setLoading(loading: true);
    _setError(error: null);

    final launchOrFailure = await fetchLaunchByIdUseCase.call(id: id);

    launchOrFailure.fold(
      (failure) => _setError(error: failure.message),
      (launch) {
        _launch = launch;
        notifyListeners();
      },
    );

    _setLoading(loading: false);
    notifyListeners();
  }

  // Fetches launches using pagination with offset and limit.
  Future<void> fetchLaunchesByPagination() async {
    if (_isFetchingMore || !_hasMore) return;

    if (offset == 0) _setLoading(loading: true);
    _setFetchingMore(fetching: true);
    _setError(error: null);

    final paginatedLaunchesOrFailure =
        await fetchLaunchesByPaginationUseCase.call(
      offset: offset,
      limit: limit,
    );

    paginatedLaunchesOrFailure.fold(
      (failure) => _setError(error: failure.message),
      (newLaunches) {
        if (newLaunches.isEmpty) {
          _hasMore = false;
        } else {
          _paginatedLaunches.addAll(newLaunches);
          offset += _paginatedLaunches.length;
        }
      },
    );

    _setFetchingMore(fetching: false);
    if (offset > 0) _setLoading(loading: false);
  }

  // Refreshes the paginated launches list by clearing current data
  // and fetching the first page again.
  Future<void> refreshLaunches() async {
    offset = 0;
    _hasMore = true;
    _paginatedLaunches.clear();
    _setLoading(loading: true);
    await fetchLaunchesByPagination();
    _setLoading(loading: false);
  }

  @override
  void dispose() {
    // Reset all state variables when provider is disposed
    _launches = [];
    _launch = LaunchEntity.dummyLaunch;
    _paginatedLaunches = [];
    _isLoading = false;
    _isFetchingMore = false;
    _hasMore = true;
    _error = null;
    _filterUpcoming = false;
    offset = 0;
    limit = 4;
    _searchQuery = '';
    _filteredLaunches = [];
    super.dispose();
  }
}
