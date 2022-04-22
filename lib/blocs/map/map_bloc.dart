import 'dart:async';

import 'package:QuizProjectJonathan/models/models.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:QuizProjectJonathan/themes/themes.dart';
import 'package:QuizProjectJonathan/blocs/blocs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;

  GoogleMapController? _mapController;
  LatLng? mapCenter;

  //limpiar la stream
  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    //manejos de los eventos de mi bloc
    on<OnMapInitialzeEvent>(_onInitMap);
    on<OnStartFollowingUserMap>(_onStartFollingUser);
    on<OnStopFollowingUserMap>(
        (event, emit) => emit(state.copyWith(isfollowUser: false)));
    //le paso la referencia del _onPolylinesNewPoint
    on<UpdateUserPolylinesMap>(_onPolylinesNewPoint);
    on<OnToggleUserRoute>((event, emit) =>
        emit(state.copyWith(showMayRoute: !state.showMayRoute)));
    //recibimos el evento para esparcirlo
    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    //seguira al usuario
    locationStateSubscription = locationBloc.stream.listen((locationState) {
      //el listado de las nuevas ubicaciones
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylinesMap(locationState.myLocationHistory));
      }
      //esto no se ejecuta si esta siguiendo el usuario
      if (!state.isfollowUser) return;
      if (locationState.lastKnowLocation == null) return;
      moveCamera(locationState.lastKnowLocation!);
    });
  }

  void _onInitMap(OnMapInitialzeEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    // _mapController?.animateCamera()
    emit(state.copyWith(isMapInitialize: true));
  }

  void _onStartFollingUser(
      OnStartFollowingUserMap event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;

    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onPolylinesNewPoint(
      UpdateUserPolylinesMap event, Emitter<MapState> emit) {
    //crea la polyline la linea mi ruta
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    //se sobre escribe y se le pasa al state y pueden ser varias
    currentPolyline['myRoute'] = myRoute;

    //state send
    emit(state.copyWith(polylines: currentPolyline));
  }

  Future drawRoutePolylines(RouteDestination destination) async {
    final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.black,
        width: 5,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms = kms / 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    //marcador
    final startMarket = Marker(
        markerId: const MarkerId('start'),
        position: destination.points.first,
        onTap: () {
          print('jola info');
        },
        infoWindow: InfoWindow(
          title: destination.startPlace.placeName,
          snippet: destination.startPlace.placeNameEs,
        ));

    //marcador
    final endMarket = Marker(
        markerId: const MarkerId('end'),
        position: destination.points.last,
        infoWindow: InfoWindow(
            title: destination.endPlace.placeName,
            snippet: destination.endPlace.placeNameEs));

    //reemplazar por unas nuevas el state no lo modificamos solo hacemos una copia porque es inmutable o const
    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    currentPolyline['route'] = myRoute;

    //añadir el markers
    final currenMarkers = Map<String, Marker>.from(state.markers);
    //se sobre escribe y se le pasa al state y pueden ser varias
    currenMarkers['start'] = startMarket;
    currenMarkers['end'] = endMarket;

    //dispara el evento
    add(DisplayPolylinesEvent(currentPolyline, currenMarkers));

    //mostrar informacion del market
    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId(
      'start',
    ));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
