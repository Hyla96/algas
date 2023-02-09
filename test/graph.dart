// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:algas/app/ui/algorithms/utils/graph.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Testing models', () {
    final matrix = AdjacencyMatrix();

    final v1 = matrix.createVertex(5);
    final v2 = matrix.createVertex(2);
    final v3 = matrix.createVertex(3);
    final v4 = matrix.createVertex(1);

    matrix.addEdge(v1, v2, weight: 5);
    matrix.addEdge(v2, v4, weight: 2);
    matrix.addEdge(v1, v3, weight: 1);
    matrix.addEdge(v4, v3, weight: 8);

    print(matrix.toString());
  });
}
