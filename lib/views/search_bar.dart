import 'package:QuizProjectJonathan/blocs/blocs.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:QuizProjectJonathan/delegate/delegates.dart';
import 'package:QuizProjectJonathan/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarket
            ? const SizedBox()
            : FadeInDown(
                duration: Duration(milliseconds: 300),
                child: const _SearchBarBody());
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    if (result.manual == true) {
      searchBloc.add(OnActivatedManualMarketEvent());
      return;
    }

    if (result.position != null) {
      final start = locationBloc.state.lastKnowLocation!;
      final end = result.position!;
      final resDestination = await searchBloc.getCoorsStartToEnd(start, end);
      await mapBloc.drawRoutePolylines(resDestination);
    }
    //todo si tenemos el result.position
    // final resDestination = await searchBloc.getCoorsStartToEnd(start, end);
    // await mapBloc.drawRoutePolylines(resDestination);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        height: 50,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            print(result);
            onSearchResult(context, result);
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
              child: const Text('Donde quieres ir?',
                  style: TextStyle(color: Colors.black87)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5))
                  ])),
        ),
      ),
    );
  }
}
