part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitialzeEvent extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitialzeEvent(this.controller);
}

class OnStopFollowingUserMap extends MapEvent {}

class OnStartFollowingUserMap extends MapEvent {}

class UpdateUserPolylinesMap extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylinesMap(this.userLocations);
}

//toggle

class OnToggleUserRoute extends MapEvent {}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  DisplayPolylinesEvent(this.polylines, this.markers);
}
