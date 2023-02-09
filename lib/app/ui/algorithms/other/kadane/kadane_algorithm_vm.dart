// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:math';

import 'package:algas/app/utils/base_vm.dart';
import 'package:algas/app/utils/constants.dart';
import 'package:algas/app/utils/running_status.dart';
import 'package:rxdart/subjects.dart';

/// https://en.wikipedia.org/wiki/Maximum_subarray_problem
///
/// Finds a contiguous subarray with the largest sum.
///
/// The runtime complexity of Kadane's algorithm is O(n).
///

class KadaneAlgorithmVM extends BaseVM {
  final startIndex = BehaviorSubject<int>.seeded(0);
  final endIndex = BehaviorSubject<int>.seeded(0);
  final currentIndex = BehaviorSubject<int>.seeded(0);
  final currentSum = BehaviorSubject<int>.seeded(0);
  final bestSum = BehaviorSubject<int>.seeded(0);

  final status = BehaviorSubject<RunningStatus>.seeded(RunningStatus.stopped);

  final numbers = BehaviorSubject<List<int>>();

  final _rng = Random();

  final delay = BehaviorSubject.seeded(defaultDelay);

  Duration get _delay => Duration(milliseconds: delay.valueOrNull ?? defaultDelay);

  void reset() {
    startIndex.add(0);
    endIndex.add(0);
    currentIndex.add(0);
    currentSum.add(0);
    bestSum.add(0);
    numbers.add([]);
  }

  Future<void> start() async {
    if (status.value == RunningStatus.running) return;
    if (status.value == RunningStatus.stopped) {
      reset();
      final values = List.generate(
        12,
        (index) => _rng.nextInt(20) * (_rng.nextBool() ? 1 : -1),
      );
      return _start(values);
    } else {
      status.add(RunningStatus.running);
    }
  }

  void stop() => status.add(RunningStatus.paused);

  Future<void> checkForPause() async {
    if (status.value == RunningStatus.paused) {
      await status.skipWhile((element) => element != RunningStatus.running).first;
    }
  }

  Future<void> _start(List<int> n) async {
    status.add(RunningStatus.running);
    numbers.add(n);
    var start = currentIndex.value;
    for (int i = 0; i < n.length; i++) {
      currentIndex.add(i);
      await Future.delayed(_delay);
      await checkForPause();
      final x = n[i];
      if (currentSum.value <= 0) {
        currentSum.add(x);
        start = i;
      } else {
        currentSum.add(currentSum.value + x);
      }
      if (currentSum.value >= bestSum.value) {
        bestSum.add(currentSum.value);
        startIndex.add(start);
        endIndex.add(i);
        await Future.delayed(_delay);
        await checkForPause();
      }
    }

    currentIndex.add(n.length);
    status.add(RunningStatus.stopped);
  }
}
