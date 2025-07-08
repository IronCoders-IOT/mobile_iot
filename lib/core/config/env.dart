import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(
  path: '.env.dev',
  obfuscate: true,
)
abstract class Env {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _Env.apiUrl;
  @EnviedField(varName: 'AUTHENTICATION_ENDPOINT')
  static final String authentication = _Env.authentication;
  @EnviedField(varName: 'EVENTS_ENDPOINT')
  static final String eventsEndpoint = _Env.eventsEndpoint;
  @EnviedField(varName: 'REQUESTS_ENDPOINT')
  static final String requestsEndpoint = _Env.requestsEndpoint;
  @EnviedField(varName: 'SENSORS_ENDPOINT')
  static final String sensorsEndpoint = _Env.sensorsEndpoint;
  @EnviedField(varName: 'WATER_REQUESTS_ENDPOINT')
  static final String waterRequestsEndpoint = _Env.waterRequestsEndpoint;
  @EnviedField(varName: 'RESIDENTS_ENDPOINT')
  static final String residentsEndpoint = _Env.residentsEndpoint;
  @EnviedField(varName: 'PROFILE_ENDPOINT')
  static final String profileEndpoint = _Env.profileEndpoint;

}