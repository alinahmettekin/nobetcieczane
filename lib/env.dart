import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'NOSY_API_KEY')
  static const String nosyApiKey = _Env.nosyApiKey;

  @EnviedField(varName: 'GMA_APP_ID_ANDROID')
  static const String gmaAppIdAndroid = _Env.gmaAppIdAndroid;

  @EnviedField(varName: 'GMA_APP_ID_IOS')
  static const String gmaAppIdIos = _Env.gmaAppIdIos;

  @EnviedField(varName: 'GMA_BANNER_I_ANDROID')
  static const String bannerIdIAndroid = _Env.bannerIdIAndroid;

  @EnviedField(varName: 'GMA_BANNER_II_ANDROID')
  static const String bannerIdIIAndroid = _Env.bannerIdIIAndroid;

  @EnviedField(varName: 'GMA_BANNER_III_ANDROID')
  static const String bannerIdIIIAndroid = _Env.bannerIdIIIAndroid;

  @EnviedField(varName: 'GMA_BANNER_I_IOS')
  static const String bannerIdIIos = _Env.bannerIdIIos;

  @EnviedField(varName: 'GMA_BANNER_II_IOS')
  static const String bannerIdIIIos = _Env.bannerIdIIIos;

  @EnviedField(varName: 'GMA_BANNER_III_IOS')
  static const String bannerIdIIIIos = _Env.bannerIdIIIIos;

  @EnviedField(varName: 'GMA_BANNER_TEST')
  static const String testBannerId = _Env.testBannerId;
}
