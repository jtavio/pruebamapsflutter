import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:QuizProjectJonathan/blocs/blocs.dart';
import 'package:QuizProjectJonathan/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
      return state.isAllGranted ? const MapsScreen() : const GpsAccessScreen();
    }));
  }
}
