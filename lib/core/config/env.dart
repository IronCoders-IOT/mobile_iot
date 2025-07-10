import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(
  path: '.env.prod',
  obfuscate: true,
)
abstract class Env {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _Env.apiUrl;
  @EnviedField(varName: 'AUTHENTICATION_ENDPOINT')
  static final String authenticationEndpoint = _Env.authenticationEndpoint;
  @EnviedField(varName: 'ISSUE_REPORTS_ENDPOINT')
  static final String issueReportsEndpoint = _Env.issueReportsEndpoint;
  @EnviedField(varName: 'DEVICES_ENDPOINT')
  static final String devicesEndpoint = _Env.devicesEndpoint;
  @EnviedField(varName: 'WATER_SUPPLY_REQUESTS_ENDPOINT')
  static final String waterSupplyRequestsEndpoint = _Env.waterSupplyRequestsEndpoint;
  @EnviedField(varName: 'RESIDENTS_ENDPOINT')
  static final String residentsEndpoint = _Env.residentsEndpoint;
  @EnviedField(varName: 'PROFILE_ENDPOINT')
  static final String profileEndpoint = _Env.profileEndpoint;


}