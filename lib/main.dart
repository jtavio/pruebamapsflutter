import 'package:QuizProjectJonathan/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:QuizProjectJonathan/blocs/blocs.dart';

import 'package:QuizProjectJonathan/screens/screens.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => GpsBloc(),
      ),
      BlocProvider(
        create: (context) => LocationBloc(),
      ),
      BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context)),
        //dependencia
      ),
      BlocProvider(
        create: (context) => SearchBloc(trafficService: TrafficService()),
      ),
    ],
    child: MapsApp(),
  ));
}

class MapsApp extends StatelessWidget {
  const MapsApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingScreen()
        //home: TextMarkerScreen()

        );
  }
}
