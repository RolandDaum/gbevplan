import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gbevplan/pages/home.dart';
import 'package:gbevplan/pages/home_subpages/help.dart';
import 'package:gbevplan/pages/home_subpages/news.dart';
import 'package:gbevplan/pages/home_subpages/originaltimetable.dart';
import 'package:gbevplan/pages/home_subpages/settings.dart';
import 'package:gbevplan/pages/home_subpages/timetable.dart';
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
          name: 'timetable',
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
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Home(child: child,);
      }
    )
  ]
);