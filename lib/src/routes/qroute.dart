import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';

typedef PageBuilder = Widget Function();
typedef PageWithChildBuilder = Widget Function(QRouter);
typedef PageWithDeclarativeBuilder = Widget Function(QKey);

/// Define a route
class QRoute {
  static QRoute empty = QRoute(path: '/', builder: () => const SizedBox());

  const QRoute({
    required this.path,
    required this.builder,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
  })  : assert(builder != null),
        observers = null,
        declarativeBuilder = null,
        initRoute = null,
        builderChild = null;

  /// Define a declarative router
  const QRoute.declarative({
    required this.path,
    required this.declarativeBuilder,
    this.name,
    this.pageType,
    this.middleware,
  })  : assert(declarativeBuilder != null),
        initRoute = null,
        observers = null,
        builderChild = null,
        builder = null,
        children = null;

  /// Call this function to get a [QRouter] to use it for Nested Navigation
  const QRoute.withChild({
    required this.path,
    required this.builderChild,
    this.initRoute,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
    this.observers,
  })  : assert(builderChild != null),
        declarativeBuilder = null,
        builder = null;

  /// The default widget builder for this route
  final PageBuilder? builder;

  /// Widget builder with a [QRouter] for the nested navigation
  /// use it with [QRoute.withChild]
  final PageWithChildBuilder? builderChild;

  /// The children for this route
  final List<QRoute>? children;

  /// used when you want to use declarative router
  final PageWithDeclarativeBuilder? declarativeBuilder;

  /// Set the initPath for the route, used with [QRoute.withChild]
  final String? initRoute;

  /// Define a Middlewares for this route
  /// with [QMiddleware] or [QMiddlewareBuilder]
  final List<QMiddleware>? middleware;

  /// The name for this route
  final String? name;

  /// A list of observers for this navigator.
  final List<NavigatorObserver>? observers;

  /// Set the page type for this route
  /// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
  /// The default is [QPlatformPage]
  final QPage? pageType;

  /// Set the path to this Route
  /// then use `QR.to()`to navigate to it.
  ///
  /// you can add path parameter easily like this:
  /// `/:id`
  /// and receive it using `QR.params['id']`
  ///
  /// More over you can add **Regex** to this parameter
  /// '`/:id(^[0-9]\$)'` any id with more than one number
  /// Will be directed to the `notfound` route
  ///
  /// Note that any regex MUST BE added between  parentheses `()`
  ///
  /// Useful regex:
  ///
  ///  `(^[0-9]*\$)` none or many numbers only.
  ///
  ///  `(^[0-9]+\$)` one or more numbers only.
  ///
  ///  `(^[0-9]\$)`  one number only.
  ///
  ///  `(foo|bar)` one value only  foo or bar.
  final String path;

  /// does this route use [QRouter]
  bool get withChildRouter => builderChild != null;

  // is this route declarative route
  bool get isDeclarative => declarativeBuilder != null;

  QRoute copyWith(
      {String? path,
      String? name,
      PageBuilder? builder,
      PageWithChildBuilder? builderChild,
      QPage? pageType,
      List<QMiddleware>? middleware,
      String? initRoute,
      List<QRoute>? children,
      List<NavigatorObserver>? observers}) {
    if (withChildRouter) {
      return QRoute.withChild(
        path: path ?? this.path,
        name: name ?? this.name,
        builderChild: builderChild ?? this.builderChild,
        pageType: pageType ?? this.pageType,
        middleware: middleware ?? this.middleware,
        initRoute: initRoute ?? this.initRoute,
        children: children ?? this.children,
        observers: observers ?? this.observers,
      );
    }

    return QRoute(
      path: path ?? this.path,
      name: name ?? this.name,
      builder: builder ?? this.builder,
      pageType: pageType ?? this.pageType,
      middleware: middleware ?? this.middleware,
      children: children ?? this.children,
    );
  }
}
