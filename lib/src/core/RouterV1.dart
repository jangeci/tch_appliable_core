import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tch_appliable_core/src/core/router/BoundaryPageRoute.dart';
import 'package:tch_appliable_core/src/core/router/FadeAnimationPageRoute.dart';
import 'package:tch_appliable_core/src/core/router/NoAnimationPageRoute.dart';
import 'package:tch_appliable_core/utils/Boundary.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Generate Route with Screen for RoutingArguments from Route name
Route<Object> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.name?.routingArguments;

  if (arguments != null) {
    switch (arguments.route) {
//    case ExampleScreen.ROUTE:
//      return createRoute((BuildContext context) => ExampleScreen(), settings);
      default:
        throw Exception('Implement OnGenerateRoute in app');
    }
  }

  throw Exception('Arguments not available');
}

/// Create Route depending on platform for different effects
Route<Object> createRoute(WidgetBuilder builder, RouteSettings settings) {
  if (kIsWeb) {
    return NoAnimationPageRoute(builder: builder, settings: settings);
  } else {
    final arguments = settings.name?.routingArguments;

    if (arguments != null && Boundary.validateRoutingJson(arguments)) {
      return BoundaryPageRoute<Object>(
        builder: builder,
        boundary: Boundary.fromRoutingJson(arguments),
        settings: settings,
        borderRadius: arguments['router-boundary-radius']?.toDouble(),
      );
    } else if (arguments?['router-no-animation'] != null) {
      return NoAnimationPageRoute<Object>(builder: builder, settings: settings);
    } else if (arguments?['router-fade-animation'] != null) {
      return FadeAnimationPageRoute<Object>(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute<Object>(builder: builder, settings: settings);
    }
  }
}

class RoutingArguments {
  final String? route;

  final Map<String, String>? _query;

  /// RoutingArguments initialization
  RoutingArguments({
    this.route,
    Map<String, String>? query,
  }) : _query = query;

  /// RoutingArguments from current ModalRoute
  static RoutingArguments? of(BuildContext context) {
    return ModalRoute.of(context)?.settings.name?.routingArguments;
  }

  /// Using [] operator gets value from query for key
  String? operator [](String key) => _query?[key];
}

extension StringExtension on String {
  /// Covert String into RoutingArguments
  RoutingArguments? get routingArguments {
    if (this.isEmpty) {
      return null;
    }

    final uri = Uri.parse(this);

    return RoutingArguments(
      route: uri.path,
      query: uri.queryParameters,
    );
  }
}

/// Push named route to stack
Future<T?> pushNamed<T extends Object>(BuildContext context, String routeName, {Map<String, String>? arguments}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return Navigator.pushNamed(context, routeName);
}

/// Push named route to stack & clear all others
Future<T?> pushNamedNewStack<T extends Object>(
  BuildContext context,
  String routeName, {
  Map<String, String>? arguments,
  RoutePredicate? predicate,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return Navigator.pushNamedAndRemoveUntil(context, routeName, predicate ?? (Route<dynamic> route) => false);
}

/// Pop the route if not yet disposed
void popNotDisposed<T extends Object?>(BuildContext context, bool mounted, [T? result]) {
  if (mounted) {
    Navigator.pop(context, result);
  }
}
