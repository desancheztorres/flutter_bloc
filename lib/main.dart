import 'package:bloc_example/bloc/bloc_supervisor.dart';
import 'package:bloc_example/blocs/counter_bloc.dart';
import 'package:bloc_example/blocs/my_bloc_delegate.dart';
import 'package:bloc_example/flutter_bloc/bloc_provider.dart';

import 'home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();

  final CounterBloc counterBloc = CounterBloc();

  runApp(
    BlocProvider<CounterBloc>(
      bloc: counterBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    ),
  );
}
