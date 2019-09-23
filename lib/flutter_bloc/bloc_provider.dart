import 'package:bloc_example/bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class BlocProvider<T extends Bloc<dynamic, dynamic>> extends InheritedWidget {
  final T bloc;

  final Widget child;

  BlocProvider({
    Key key,
    @required this.bloc,
    this.child,
  })  : assert(bloc != null),
        super(key: key, child: child);

  static T of<T extends Bloc<dynamic, dynamic>>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();

    final BlocProvider<T> provider = context
        .ancestorInheritedElementForWidgetOfExactType(type)
        ?.widget as BlocProvider<T>;

    if (provider == null) {
      throw FlutterError(
        "BlocProvider.of() called with context that does not contain a Bloc of type $T.",
      );
    }

    return provider?.bloc;
  }

  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>(
      key: key,
      bloc: bloc,
      child: child,
    );
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(BlocProvider oldWidget) => false;
}
