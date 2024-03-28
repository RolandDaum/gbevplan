import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gbevplan/pages/page_home.dart';
import 'package:gbevplan/pages/home_subpages/page_help.dart';
import 'package:gbevplan/pages/home_subpages/page_news.dart';
import 'package:gbevplan/pages/home_subpages/subpage_settings_changetimetable.dart';
import 'package:gbevplan/pages/home_subpages/subpage_timetable_original.dart';
import 'package:gbevplan/pages/home_subpages/page_settings.dart';
import 'package:gbevplan/pages/home_subpages/page_timetable.dart';
import 'package:gbevplan/pages/page_login.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const page_Login();
      }
    ), 
    ShellRoute(
      routes: [
        GoRoute(
          path: '/timetable',
          name: 'timetable',
          builder: (BuildContext context, GoRouterState state) {
            return page_TimeTable(); 
          } 
        ),
        GoRoute(
          path: '/timetable_original',
          builder: (BuildContext context, GoRouterState state) {
            return page_OrgTimeTable(); 
          }
        ),
        GoRoute(
          path: '/news',
          builder: (BuildContext context, GoRouterState state) {
            return page_News(); 
          }
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return page_Settings(); 
          }
        ),
        GoRoute(
          path: '/settings_changetimetable',
          builder: (context, state) {
            return page_ChangeTimetable();
          },
        ),
        GoRoute(
          path: '/help',
          builder: (BuildContext context, GoRouterState state) {
            return page_Help(); 
          }
        ),
      ],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return page_Home(child: child,);
      }
    )
  ]
);