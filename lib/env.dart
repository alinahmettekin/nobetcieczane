import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'NOSY_API_KEY')
  static const String nosyApiKey = _Env.nosyApiKey;

  @EnviedField(varName: 'GMA_BANNER_I')
  static const String bannerIdI = _Env.bannerIdI;

  @EnviedField(varName: 'GMA_BANNER_II')
  static const String bannerIdII = _Env.bannerIdII;

  @EnviedField(varName: 'GMA_BANNER_III')
  static const String bannerIdIII = _Env.bannerIdIII;

  @EnviedField(varName: 'GMA_BANNER_TEST')
  static const String testBannerId = _Env.testBannerId;
}
