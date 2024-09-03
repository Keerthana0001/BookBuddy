import 'package:bookbuddy/auth/login.dart';
import 'package:bookbuddy/home/home.dart';
import 'package:bookbuddy/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LogIn()),
  
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => MaterialPage(child: Home()),
  '/profile': (route) => MaterialPage(child: UserProfilePage()),

});
