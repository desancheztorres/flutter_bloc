import 'package:bloc_example/bloc/bloc.dart';
import 'package:bloc_example/bloc/bloc_delegate.dart';
import 'package:bloc_example/bloc/transition.dart';

class MyBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('bloc: ${bloc.runtimeType}, error: $error, stacktrace: $stacktrace');
  }
}
