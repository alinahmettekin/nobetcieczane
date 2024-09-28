import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/credentials/credentials.dart';

class GoogleAds extends ChangeNotifier {
  static GoogleAds? _instance;
  static GoogleAds get instance {
    return _instance ??= GoogleAds._internal();
  }

  GoogleAds._internal();

  BannerAd? bannerAd;

  final _adUnitId = Credentials.instance.adUnitId;

  loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }
}
