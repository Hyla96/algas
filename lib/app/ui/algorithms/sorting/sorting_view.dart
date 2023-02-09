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
import 'package:algas/app/ui/algorithms/sorting/vm/vm.dart';
import 'package:algas/app/utils/constants.dart';
import 'package:algas/app/utils/running_status.dart';
import 'package:flutter/material.dart';

class SortingView extends StatelessWidget {
  const SortingView({
    required this.vm,
    Key? key,
  }) : super(key: key);

  SortingView.bubbleSort({
    Key? key,
  })  : vm = BubbleSortVM(),
        super(key: key);

  final SortingVM vm;

  final height = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            Text('BubbleSort'),
            SizedBox(
              child: StreamBuilder<List<int>>(
                stream: vm.list.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container();
                  }
                  final list = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(
                              list.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                                child: Container(
                                  height: (height * list[index]) / maxSortingNumber,
                                  width: 3,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: 150,
                        child: StreamBuilder<int>(
                          stream: vm.delay$,
                          initialData: defaultDelay,
                          builder: (context, snapshot) {
                            final velocity = (200 - snapshot.data!) + 1;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Text('Speed:'),
                                ),
                                Slider(
                                  value: velocity.toDouble(),
                                  max: 200,
                                  min: 1,
                                  onChanged: (double value) => vm.setDelay(
                                    (200 - value + 1).round(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<RunningStatus>(
            stream: vm.status.stream,
            initialData: RunningStatus.stopped,
            builder: (context, snapshot) {
              return FloatingActionButton(
                heroTag: 'play',
                onPressed: () async => snapshot.data! != RunningStatus.running ? vm.start() : vm.pause(),
                child: Icon(
                  snapshot.data! != RunningStatus.running ? Icons.play_arrow : Icons.stop,
                ),
              );
            },
          ),
          SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () async => vm.reset(),
            child: const Icon(
              Icons.restart_alt,
            ),
          )
        ],
      ),
    );
  }
}
