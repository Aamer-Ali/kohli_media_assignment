import 'package:flutter/material.dart';
import '../authentication_page.dart';
import '../todo_list_page.dart';

class AppRoutes {
  static const String kAuthenticationPage = "/authentication-page";
  static const String kTodoListPage = "/todolist-page";

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.kAuthenticationPage:
        return _materialRoute(const AuthenticationPage());
      case AppRoutes.kTodoListPage:
        return _materialRoute(const TodoListPage());
      default:
        return null;
    }
  }

  static Route<dynamic>? _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
