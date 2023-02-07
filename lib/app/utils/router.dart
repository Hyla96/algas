// Copyright (c) 2023 Costache Nicu Gabriel.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the  GNU General Public License
// as published by the Free Software Foundation, either version 3  of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:algas/app/ui/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._privateConstructor();
  static final AppRouter _instance = AppRouter._privateConstructor();
  static AppRouter get instance => _instance;

  final routes = <String, Widget>{
    '/': HomePage(),
    '/kadane': KadaneAlgorithm(),
  };

  GoRouter get router => GoRouter(
        routes: routes.keys
            .map(
              (e) => GoRoute(
                path: e,
                builder: (context, state) => routes[e]!,
              ),
            )
            .toList(),
      );
}
