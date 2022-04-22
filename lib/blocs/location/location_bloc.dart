import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  LocationBloc() : super(const LocationState(lastKnowLocation: null)) {
    on<OnStartFollowingUser>(
        (event, emit) => emit(state.copyWith(followingUser: true)));
    on<OnStopFollowingUser>(
        (event, emit) => emit(state.copyWith(followingUser: false)));

    on<OnNewuserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnowLocation: event.newLocation,
        //se almacenan mis puntos de la historia en el recorrido
        myLocationHistory: [...state.myLocationHistory, event.newLocation],
      ));
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    print('position: $position');
    //retornar un objeto de tipo lat y logn
    //puedo modificar la latitud y longitud
    // add(OnNewuserLocationEvent(LatLng(4.545367057195659, -76.09435558319092)));
    add(OnNewuserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    print('startFollowingUser');
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      print('event: $position');
      //puedo modificar la latitud y longitud

      // add(OnNewuserLocationEvent(LatLng(4.545367057195659, -76.09435558319092)));
      add(OnNewuserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    add(OnStopFollowingUser());
    print('stopFollowingUser');
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
