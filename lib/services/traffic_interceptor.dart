import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1Ijoiam9uYXRoYW4yOSIsImEiOiJja3EwZnphdnEwNGp5Mnd0ZTlnNmVseXpuIn0.bP67qd2b5HmQ5qQcCFrA0A';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}
