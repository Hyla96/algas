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

import 'package:algas/app/utils/constants.dart';
import 'package:algas/app/utils/running_status.dart';
import 'package:rxdart/subjects.dart';

abstract class SortingVM {
  SortingVM() {
    reset();
  }

  final _rng = Random();

  final list = BehaviorSubject<List<int>>();
  final _delay = BehaviorSubject.seeded(defaultDelay);

  final status = BehaviorSubject<RunningStatus>.seeded(RunningStatus.stopped);

  Duration get delay => Duration(milliseconds: _delay.valueOrNull ?? defaultDelay);
  Stream<int> get delay$ => _delay.stream;
  void setDelay(int value) => _delay.add(value);

  void reset([int length = sortingArrayLength]) {
    status.add(RunningStatus.stopped);
    list.add(
      List.generate(
        length,
        (index) => _rng.nextInt(99),
      ),
    );
  }

  void pause() {
    status.add(RunningStatus.paused);
  }

  void resume() {
    status.add(RunningStatus.running);
  }

  /// Returns false if the algorithm is stopped.
  /// Call this function within a loop to iterate through the algorithm.
  /// Exit the loop if the function returns false.
  Future<bool> iteration(Function callback) async {
    await Future.delayed(delay);

    if (status.value == RunningStatus.running) {
      callback();
    } else if (status.value == RunningStatus.paused) {
      final nextStatus = await status.firstWhere((element) => element != RunningStatus.paused);

      if (nextStatus == RunningStatus.running) {
        callback();
      } else {
        return false;
      }
    } else {
      return false;
    }

    return true;
  }

  Future<void> sort();

  void start() {
    if (status.valueOrNull == RunningStatus.stopped) {
      sort();
    }
    resume();
  }
}
