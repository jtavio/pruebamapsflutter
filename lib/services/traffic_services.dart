import 'package:QuizProjectJonathan/models/models.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:QuizProjectJonathan/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

//TODO configurar interceptores
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future<TrafficRes> getCoorsStarToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final res = await _dioTraffic.get(url);

    final data = TrafficRes.fromMap(res.data);

    return data;
  }

  Future<List<Feature>> getResultaByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';

    final resp = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'limit': 6
    });

    //todo convertir los datos con fromjson()
    final placesResponses = PlacesRes.fromMap(resp.data);

    return placesResponses.features;
  }

  Future<Feature> getInformationByCoors(LatLng coors) async {
    final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {'limit': 1});

    final placesResponse = PlacesRes.fromMap(resp.data);
    return placesResponse.features[0];
  }
}
