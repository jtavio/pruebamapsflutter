import 'package:flutter/material.dart';
import 'package:QuizProjectJonathan/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GpsAccessScreen extends StatefulWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  State<GpsAccessScreen> createState() => _GpsAccessScreenState();
}

class _GpsAccessScreenState extends State<GpsAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        Center(child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
      return !state.isGpsEnabled
          ? const _EnableGpsMessage()
          : const _AccessBottom();
    })
            //_AccessBottom()
            ));
  }
}

class _AccessBottom extends StatelessWidget {
  const _AccessBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('es necesario el acceso a GPS'),
        MaterialButton(
            child: const Text('Solicitar Acceso',
                style: TextStyle(color: Colors.white)),
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.aksGpsAccess();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Debe habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
