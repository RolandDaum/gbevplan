import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gbevplan/pages/home.dart';
import 'package:gbevplan/pages/home_pages/help.dart';
import 'package:gbevplan/pages/home_pages/news.dart';
import 'package:gbevplan/pages/home_pages/originaltimetable.dart';
import 'package:gbevplan/pages/home_pages/settings.dart';
import 'package:gbevplan/pages/home_pages/timetable.dart';
import 'package:gbevplan/pages/login.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      }
    ), 
    ShellRoute(
      routes: [
        GoRoute(
          path: '/timetable',
          builder: (BuildContext context, GoRouterState state) {
            return TimeTable(); 
          }
        ),
        GoRoute(
          path: '/news',
          builder: (BuildContext context, GoRouterState state) {
            return News(); 
          }
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return Settings(); 
          }
        ),
        GoRoute(
          path: '/help',
          builder: (BuildContext context, GoRouterState state) {
            return Help(); 
          }
        ),
        GoRoute(
          path: '/originaltimetable',
          builder: (BuildContext context, GoRouterState state) {
            return OrgTimeTable(); 
          }
        )
      ],
      builder: (BuildContext context, GoRouterState state, child) {
        return Home(child: child,);
      }
    )
  ]
);