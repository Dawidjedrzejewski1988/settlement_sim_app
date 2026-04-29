import 'dart:async';
import 'dart:developer' as dev;

class LiveRefreshController {
  Timer? _timer;
  bool _isRefreshing = false;

  void start({
    required Future<void> Function() onRefresh,
    Duration interval = const Duration(seconds: 5),
  }) {
    stop();

    _timer = Timer.periodic(interval, (_) async {
      if (_isRefreshing) return;

      _isRefreshing = true;

      try {
        await onRefresh();
      } catch (e) {
        dev.log("Live refresh error", error: e);
      } finally {
        _isRefreshing = false;
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null;
}