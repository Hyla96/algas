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
  AppRouter._privateConstructor() {
    _router = GoRouter(
      routes: routes
          .map(
            (e) => GoRoute(
              path: e.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: e.page,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          )
          .toList(),
    );
  }
  static final AppRouter _instance = AppRouter._privateConstructor();
  static AppRouter get instance => _instance;

  late GoRouter _router;

  GoRouter get router => _router;

  final routes = <Route>[
    const Route(
      name: 'Home',
      path: '/',
      page: HomePage(),
    ),
    Route(
      name: 'Kadane Algorithm',
      path: '/kadane',
      page: KadaneAlgorithm(),
    ),
    Route(
      name: 'Bubble Sort',
      path: '/bubble-sort',
      page: SortingView.bubbleSort(),
    ),
  ];
}

class Route {
  const Route({
    required this.name,
    required this.page,
    required this.path,
  });

  final String name;
  final Widget page;
  final String path;
}
