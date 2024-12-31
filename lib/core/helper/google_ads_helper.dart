import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/credentials/credentials.dart';
import 'package:nobetcieczane/core/utils/network_utils.dart';

class GoogleAds extends ChangeNotifier {
  static GoogleAds? _instance;
  static GoogleAds get instance {
    return _instance ??= GoogleAds._internal();
  }

  GoogleAds._internal();

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  final _bannerAdUnitId = Credentials.instance.testBannerAdUnitId;
  final _interstitialAdUnitId = Credentials.instance.testInterstitialAdUnitId;

  loadBannerAd() async {
    List<ConnectivityResult> connectivityResult = await NetworkUtils.instance.checkConnections();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
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
    } else {
      return;
    }
  }

  void loadInterstitialAd() async {
    List<ConnectivityResult> connectivityResult = await NetworkUtils.instance.checkConnections();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ),
      );
    }
  }
}
