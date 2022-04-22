import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;
  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsAndpermissionEvent>((event, emit) {
      return emit(state.copyWith(
          isGpsEnabled: event.isGpsEnabled,
          isGpsPermissionGranted: event.isGpsPermissionGranted));
    });
    _init();
  }

  Future<void> _init() async {
    // final statusChek = await _checkGpsStatus();
    // final isGranted = await _isPermissionGrantend();
    // print('statuscheck $statusChek, isGranted $isGranted');

    final gpsInitStatus =
        await Future.wait([_checkGpsStatus(), _isPermissionGrantend()]);

    add(GpsAndpermissionEvent(
        isGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[0]));
  }

  Future<bool> _isPermissionGrantend() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      print('services status $isEnabled');
      add(GpsAndpermissionEvent(
          isGpsEnabled: isEnabled,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });

    return isEnabled;
  }

  Future<void> aksGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndpermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndpermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false));
        openAppSettings();
    }
  }

  //limpiar el listener de serivces status stream
  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
