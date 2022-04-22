import 'package:QuizProjectJonathan/models/models.dart';
import 'package:QuizProjectJonathan/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    //cambiamos el estado , se contruye una vez
    on<OnActivatedManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: true)));
    on<OffDeactivatedManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: false)));
    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));
    //todo el ultimo al inicio [event.placesHistory, ...state.history]
    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.placesHistory, ...state.history])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final resp = await trafficService.getCoorsStarToEnd(start, end);

    //informaciondel destino
    final startPlace = await trafficService.getInformationByCoors(start);
    print('startPlace: $startPlace');
    final endPlace = await trafficService.getInformationByCoors(end);
    print('endPlace: $endPlace');

    final distance = resp.routes[0].distance;
    final duration = resp.routes[0].duration;
    final geometry = resp.routes[0].geometry;

    //decodificar
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
        distance: distance,
        duration: duration,
        points: latLngList,
        startPlace: startPlace,
        endPlace: endPlace);
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultaByQuery(proximity, query);
    //Todo aqui se hara el almacenamientoen el state
    add(OnNewPlacesFoundEvent(newPlaces));
  }
}
