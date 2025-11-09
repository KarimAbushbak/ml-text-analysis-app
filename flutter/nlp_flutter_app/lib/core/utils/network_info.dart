import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility class to check network connectivity
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Factory constructor to create NetworkInfo with default connectivity
  static NetworkInfo create() {
    return NetworkInfo(Connectivity());
  }

  /// Check if device has internet connection
  /// Returns true if connected to WiFi, Mobile, or Ethernet
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnectedResult(result);
    } catch (e) {
      // If we can't check connectivity, assume we're not connected
      return false;
    }
  }

  /// Get a stream of connectivity changes
  /// Useful for monitoring connection status in real-time
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return _isConnectedResult(result);
    });
  }

  /// Helper method to determine if connectivity result means we're connected
  bool _isConnectedResult(List<ConnectivityResult> result) {
    if (result.isEmpty) return false;
    
    return result.any((item) =>
        item == ConnectivityResult.mobile ||
        item == ConnectivityResult.wifi ||
        item == ConnectivityResult.ethernet);
  }
}

