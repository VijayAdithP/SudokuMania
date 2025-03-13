import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
class TimeState {
  final int elapsedMilliseconds;
  final bool isRunning;

  const TimeState({
    required this.elapsedMilliseconds,
    required this.isRunning,
  });
}

class TimeStateNotifier extends StateNotifier<TimeState> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _savedElapsedTime = 0;

  TimeStateNotifier()
      : super(TimeState(elapsedMilliseconds: 0, isRunning: false));

  void start() {
    if (!_stopwatch.isRunning) {
      // Don't reset the stopwatch here
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        final currentElapsed =
            _stopwatch.elapsedMilliseconds + _savedElapsedTime;
        state = TimeState(
          elapsedMilliseconds: currentElapsed,
          isRunning: true,
        );
      });
    }
  }

  void stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _savedElapsedTime += _stopwatch.elapsedMilliseconds;
      _stopwatch.reset();
      _timer?.cancel();
      state = TimeState(
        elapsedMilliseconds: _savedElapsedTime,
        isRunning: false,
      );
    }
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _savedElapsedTime = 0;
    _timer?.cancel();
    state = TimeState(
      elapsedMilliseconds: 0,
      isRunning: false,
    );
  }

  int getElapsedTime() {
    if (_stopwatch.isRunning) {
      return _savedElapsedTime + _stopwatch.elapsedMilliseconds;
    }
    return _savedElapsedTime;
  }

  void addTime(int time) {
    _savedElapsedTime = time;
    state = TimeState(
      elapsedMilliseconds: time,
      isRunning: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}

// Provider definition
final timeProvider = StateNotifierProvider<TimeStateNotifier, TimeState>((ref) {
  return TimeStateNotifier();
});
