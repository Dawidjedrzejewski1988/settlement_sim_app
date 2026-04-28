// lib/controllers/live_refresh_controller.dart

import 'dart:async';

class LiveRefreshController {
  Timer? _timer;

  void start({
    required Future<void> Function() onRefresh,
  }) {
    stop();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        await onRefresh();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null;
}
