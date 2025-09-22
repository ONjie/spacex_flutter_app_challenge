import 'package:internet_connection_checker/internet_connection_checker.dart';

// Abstract class defining network info functionality.
abstract class NetworkInfo {
// Returns true if device has an internet connection, false otherwise.
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
 final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

// Returns true if there is an active internet connection.
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
