import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// ConnectionChecker is an abstract class that contains the isConnected method
abstract interface class ConnectionChecker {
  /// isConnected is a method that returns a boolean value
  Future<bool> get isConnected;
}

/// ConnectionCheckerImpl is a class that implements [ConnectionChecker]
class ConnectionCheckerImpl implements ConnectionChecker {
  /// ConnectionCheckerImpl constructor
  ConnectionCheckerImpl(this.internetConnection);

  /// ConnectionCheckerImpl constructor
  final InternetConnection internetConnection;
  @override
  Future<bool> get isConnected async => internetConnection.hasInternetAccess;
}
