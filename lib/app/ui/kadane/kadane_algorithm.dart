// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:algas/app/ui/kadane/kadane_algorithm_vm.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class KadaneAlgorithm extends StatelessWidget {
  KadaneAlgorithm({Key? key}) : super(key: key);

  final vm = KadaneAlgorithmVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<int>>(
        stream: vm.numbers.stream,
        builder: (context, numbersSnapshot) {
          return Row(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  StreamBuilder<int>(
                    stream: vm.delay.stream,
                    initialData: defaultDelay,
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delay: ${snapshot.data}ms'),
                          Slider(
                            value: snapshot.data!.toDouble(),
                            max: 2000,
                            min: 50,
                            onChanged: (double value) {
                              vm.delay.add(value.round());
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      numbersSnapshot.hasData ? numbersSnapshot.data.toString() : 'Start a new play',
                    ),
                    if (numbersSnapshot.hasData)
                      StreamBuilder<List<int>>(
                        stream: Rx.combineLatest3(
                          vm.currentIndex.stream,
                          vm.startIndex.stream,
                          vm.endIndex.stream,
                          (int a, int b, int c) => [a, b, c],
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          final c = snapshot.data![0];
                          final s = snapshot.data![1];
                          final e = snapshot.data![2];

                          return Wrap(
                            children: List.generate(
                              numbersSnapshot.data!.length,
                              (index) {
                                /// 0 => Green / Current
                                /// 1 => White / Not in the subarray
                                /// 2 => Blue / In the subarray
                                final type = index == s ? 2 : (index == e ? 2 : (index == c ? 0 : (index > s && index < e ? 2 : 1)));

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(15),
                                    color: type == 0 ? Colors.green : (type == 1 ? Colors.white : Colors.blue),
                                    child: SizedBox(
                                      height: 75,
                                      width: 75,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Center(
                                          child: Text(
                                            numbersSnapshot.data![index].toString(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: type == 0 ? Colors.white : (type == 1 ? Colors.black87 : Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    StreamBuilder<int>(
                      stream: vm.bestSum.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == 0) {
                          return const SizedBox();
                        }
                        return Text(
                          'Best sum: ${snapshot.data}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => vm.start(),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
