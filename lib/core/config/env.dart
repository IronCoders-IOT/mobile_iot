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
  static final String authentication = _Env.authentication;

}