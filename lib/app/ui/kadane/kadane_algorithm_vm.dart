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
import 'package:rxdart/subjects.dart';

/// https://en.wikipedia.org/wiki/Maximum_subarray_problem
///
/// Finds a contiguous subarray with the largest sum.
///
/// The runtime complexity of Kadane's algorithm is O(n).
///

const defaultDelay = 250;

class KadaneAlgorithmVM extends BaseVM {
  final startIndex = BehaviorSubject<int>.seeded(-1);
  final endIndex = BehaviorSubject<int>.seeded(-1);
  final currentIndex = BehaviorSubject<int>.seeded(0);
  final currentSum = BehaviorSubject<int>();
  final bestSum = BehaviorSubject<int>();

  final numbers = BehaviorSubject<List<int>>();

  final _rng = Random();

  final delay = BehaviorSubject.seeded(defaultDelay);

  Duration get _delay => Duration(milliseconds: delay.valueOrNull ?? defaultDelay);

  void reset() {
    startIndex.add(-1);
    endIndex.add(-1);
    currentIndex.add(0);
    currentSum.add(0);
    bestSum.add(0);
    numbers.add([]);
  }

  Future<void> start() async {
    reset();
    final values = List.generate(
      12,
      (index) => _rng.nextInt(20) * (_rng.nextBool() ? 1 : -1),
    );

    return _start(values);
  }

  Future<void> _start(List<int> n) async {
    numbers.add(n);
    await Future.delayed(_delay);
    var bSum = 0;
    var bStart = 0;
    var bEnd = 0;
    var cSum = 0;
    var cStart = 0;

    for (int i = 0; i < n.length; i++) {
      currentIndex.add(i);
      final x = n[i];
      if (cSum <= 0) {
        cSum = x;
        cStart = i;
      } else {
        cSum += x;
      }
      currentSum.add(cSum);
      await Future.delayed(_delay);

      if (cSum > bSum) {
        bSum = cSum;
        bStart = cStart;
        bEnd = i;
        startIndex.add(bStart);
        endIndex.add(bEnd);
        await Future.delayed(_delay);
        bestSum.add(bSum);
        await Future.delayed(_delay);
      }
    }

    currentIndex.add(n.length);
  }
}
