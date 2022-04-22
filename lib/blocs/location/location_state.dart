part of 'location_bloc.dart';

class LocationState extends Equatable {
  //seguir al usuario
  final bool followingUser;
  //ultimo geolocation
  final LatLng? lastKnowLocation;
  // historia objeto
  final List<LatLng> myLocationHistory;

  const LocationState(
      {this.followingUser = false, this.lastKnowLocation, myLocationHistory})
      : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
          followingUser: followingUser ?? this.followingUser,
          lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
          myLocationHistory: myLocationHistory ?? this.myLocationHistory);

  //con equatable compara propiedas
  @override
  List<Object?> get props =>
      [followingUser, lastKnowLocation, myLocationHistory];
}
