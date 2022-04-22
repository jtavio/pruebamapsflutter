part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialize;
  final bool isfollowUser;
  final bool showMayRoute;
  //polylines direccion o ruta
  // inicializar objetos final y se creara el evento para modificar el polylines
  final Map<String, Polyline> polylines;
  //mapa de marcadores
  final Map<String, Marker> markers;

  //puedo tener multiples polylines
  /// miruta{
  /// id:polylineid google
  ///  point [lat,lng], []
  /// width: 3
  /// color
  /// }

  const MapState({
    this.isMapInitialize = false,
    this.isfollowUser = true,
    this.showMayRoute = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};
  // inicializar objetos final

  MapState copyWith({
    bool? isMapInitialize,
    bool? isfollowUser,
    bool? showMayRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapState(
          isMapInitialize: isMapInitialize ?? this.isMapInitialize,
          isfollowUser: isfollowUser ?? this.isfollowUser,
          showMayRoute: showMayRoute ?? this.showMayRoute,
          polylines: polylines ?? this.polylines,
          markers: markers ?? this.markers);

  //puede ser distinto
  @override
  List<Object> get props =>
      [isMapInitialize, isfollowUser, polylines, showMayRoute, markers];
}
