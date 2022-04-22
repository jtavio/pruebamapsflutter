part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class OnNewuserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  const OnNewuserLocationEvent(this.newLocation);
}

class OnStartFollowingUser extends LocationEvent {}

class OnStopFollowingUser extends LocationEvent {}
