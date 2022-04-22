import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:QuizProjectJonathan/blocs/blocs.dart';

class ToggleUserRoute extends StatelessWidget {
  const ToggleUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 25,
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              //dispara un followuser
              mapBloc.add(OnToggleUserRoute());
            },
          )),
    );
  }
}
