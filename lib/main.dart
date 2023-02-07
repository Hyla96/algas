// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:algas/app/utils/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: AppRouter.instance.routes.keys
                    .map(
                      (e) => ListTile(
                        title: Text(e),
                        onTap: () => AppRouter.instance.router.go(e),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: MaterialApp.router(
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                routerConfig: AppRouter.instance.router,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
