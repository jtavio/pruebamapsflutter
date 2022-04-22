import 'package:QuizProjectJonathan/helper/helperimport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:QuizProjectJonathan/blocs/blocs.dart';

class ManualMarket extends StatelessWidget {
  const ManualMarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return state.displayManualMarket
          ? const _ManualMarketBody()
          : const SizedBox();
    });
  }
}

class _ManualMarketBody extends StatelessWidget {
  const _ManualMarketBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //mis referencias
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(top: 75, left: 30, child: BtnBack()),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                  from: 100,
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 50,
                  )),
            ),
          ),
          //Boton de confirmar
          Positioned(
              bottom: 70,
              left: 40,
              child: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: MaterialButton(
                    child: const Text(
                      'Confirmar destino',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    color: Colors.black,
                    elevation: 0,
                    height: 40,
                    shape: const StadiumBorder(),
                    minWidth: size.width - 120,
                    onPressed: () async {
                      final start = locationBloc.state.lastKnowLocation;
                      if (start == null) return;

                      final end = mapBloc.mapCenter;
                      if (end == null) return;

                      showLoadingMessage(context);

                      //todo loading
                      final resDestination =
                          await searchBloc.getCoorsStartToEnd(start, end);
                      await mapBloc.drawRoutePolylines(resDestination);
                      searchBloc.add(OffDeactivatedManualMarketEvent());
                      Navigator.pop(context);
                    }),
              ))
        ],
      ),
    );
  }
}

class BtnBack extends StatelessWidget {
  const BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              BlocProvider.of<SearchBloc>(context)
                  .add(OffDeactivatedManualMarketEvent());
            },
          )),
    );
  }
}
