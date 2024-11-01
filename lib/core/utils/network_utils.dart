import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static NetworkUtils? _instance;

  static NetworkUtils get instance {
    return _instance ??= NetworkUtils._internal();
  }

  NetworkUtils._internal();

  Future<List<ConnectivityResult>> checkConnections() async {
    final Connectivity connectivity = Connectivity();
    final List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult;
  }
}
