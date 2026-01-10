import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/util/app_logger.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
}

@LazySingleton(as: ConnectivityService)
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  ConnectivityServiceImpl(this._connectivity) {
    _connectivity.onConnectivityChanged.listen((results) {
       // connectivity_plus 6.0+ returns List<ConnectivityResult>
      _checkStatus(results);
    });
  }

  void _checkStatus(List<ConnectivityResult> results) {
     final isOnline = results.contains(ConnectivityResult.mobile) ||
                      results.contains(ConnectivityResult.wifi) ||
                      results.contains(ConnectivityResult.ethernet);
    _controller.add(isOnline);
    AppLogger.i('Connectivity changed: ${isOnline ? "Online" : "Offline"}');
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
           results.contains(ConnectivityResult.wifi) ||
           results.contains(ConnectivityResult.ethernet);
  }
}
