// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:algas/app/ui/algorithms/sorting/sorting_vm.dart';
import 'package:algas/app/utils/running_status.dart';

class BubbleSortVM extends SortingVM {
  BubbleSortVM() : super();

  @override
  Future<void> sort() async {
    final list = this.list.valueOrNull;
    if (list == null) return;

    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list.length - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          final keep = await iteration(
            () {
              final temp = list[j];
              list[j] = list[j + 1];
              list[j + 1] = temp;
              this.list.add(list);
            },
          );
          if (!keep) return;
        }
      }
    }

    status.add(RunningStatus.stopped);
  }
}
