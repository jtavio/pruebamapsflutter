part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndpermissionEvent extends GpsEvent {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  GpsAndpermissionEvent(
      {required this.isGpsEnabled, required this.isGpsPermissionGranted});
}
