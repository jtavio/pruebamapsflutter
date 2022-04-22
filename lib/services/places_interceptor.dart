import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1Ijoiam9uYXRoYW4yOSIsImEiOiJja3EwZnphdnEwNGp5Mnd0ZTlnNmVseXpuIn0.bP67qd2b5HmQ5qQcCFrA0A';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });
    super.onRequest(options, handler);
  }
}
