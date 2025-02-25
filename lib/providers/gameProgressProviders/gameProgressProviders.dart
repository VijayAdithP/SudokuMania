import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// class TimeStateNotifier extends StateNotifier<int> {
//   final Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;

//   TimeStateNotifier() : super(0);

//   void start() {
//     if (!_stopwatch.isRunning) {
//       _stopwatch.start();
//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         state = _stopwatch.elapsed.inMilliseconds;
//       });
//     }
//   }

//   void stop() {
//     if (_stopwatch.isRunning) {
//       _timer?.cancel(); // Cancel timer before stopping
//       _stopwatch.stop();
//       state = _stopwatch.elapsed.inMilliseconds;
//     }
//   }

//   void reset() {
//     _timer?.cancel();
//     _stopwatch.stop(); // Stop before resetting
//     _stopwatch.reset();
//     state = 0;
//   }

//   int getElapsedTime() {
//     return state;
//   }
// }

// class TimeStateNotifier extends StateNotifier<int> {
//   Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;
//   int _savedElapsedTime = 0; // Store elapsed time before stopping

//   TimeStateNotifier() : super(0);

//   void start() {
//     _stopwatch.start();
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       state = _stopwatch.elapsedMilliseconds + _savedElapsedTime;
//     });
//   }

//   void stop() {
//     _stopwatch.stop();
//     _savedElapsedTime += _stopwatch.elapsedMilliseconds; // Save elapsed time
//     _stopwatch.reset();
//     _timer?.cancel();
//   }

//   void reset() {
//     _stopwatch.reset();
//     _savedElapsedTime = 0;
//     state = 0;
//   }

//   int getElapsedTime() {
//     return _savedElapsedTime + _stopwatch.elapsedMilliseconds;
//   }

//   void addTime(int time) {
//     _savedElapsedTime = time; // Restore saved time
//     state = time;
//   }
// }

// class TimeStateNotifier extends StateNotifier<int> {
//   Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;
//   int _savedElapsedTime = 0; // Store elapsed time before stopping

//   TimeStateNotifier() : super(0);

//   void start() {
//     _stopwatch.start(); // Do NOT reset here
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       state = _stopwatch.elapsedMilliseconds + _savedElapsedTime;
//     });
//   }

//   void stop() {
//     _stopwatch.stop();
//     _savedElapsedTime += _stopwatch.elapsedMilliseconds; // Save elapsed time
//     _stopwatch.reset(); // Reset only the stopwatch, not _savedElapsedTime
//     _timer?.cancel();
//   }

//   void reset() {
//     _stopwatch.reset();
//     _savedElapsedTime = 0;
//     state = 0;
//   }

//   int getElapsedTime() {
//     return _savedElapsedTime +
//         (_stopwatch.isRunning ? _stopwatch.elapsedMilliseconds : 0);
//   }

//   void addTime(int time) {
//     _savedElapsedTime = time; // Restore previous elapsed time
//     state = time;
//   }
// }

// final timeProvider = StateNotifierProvider<TimeStateNotifier, int>(
//   (ref) => TimeStateNotifier(),
// );
// TimeState to hold the current time state
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
