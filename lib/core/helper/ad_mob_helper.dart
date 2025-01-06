import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetcieczane/core/credentials/credentials.dart';

/// AdConfig is a class that contains the ad configuration
class AdConfig {
  static const bool _isDebug = kDebugMode;

  /// firstBannerAdUnitId is a AdMob banner ad unit id
  static String get firstBannerAdUnitId => _isDebug
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
      : Credentials.instance.homeBannerAdUnitId;

  /// secondBannerAdUnitId is a AdMob banner ad unit id
  static String get secondBannerAdUnitId => _isDebug
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
      : Credentials.instance.mapBannerAdUnitId;

  /// thirdBannerAdUnitId is a AdMob banner ad unit id
  static String get thirdBannerAdUnitId => _isDebug
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
      : Credentials.instance.pharmaciesBannerAdUnitId;
}

/// BannerAdType is an enum that contains the banner ad types
enum BannerAdType {
  /// firstBanner is the first banner ad type
  firstBanner,

  /// secondBanner is the second banner ad type
  secondBanner,

  /// thirdBanner is the third banner ad type
  thirdBanner,
}

/// AdMobBannerWidget is a class that contains the AdMob banner widget
class AdMobBannerWidget extends StatefulWidget {
  /// AdMobBannerWidget constructor
  const AdMobBannerWidget({
    required this.type,
    super.key,
    this.loadingWidget,
    this.width,
    this.height,
  });

  /// type is a final variable of type BannerAdType
  final BannerAdType type;

  /// loadingWidget for the widget that will be
  /// displayed while the ad is loading
  final Widget? loadingWidget;

  /// width is the width of the banner ad
  final double? width;

  /// height is the height of the banner ad
  final double? height;

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  String get _adUnitId {
    switch (widget.type) {
      case BannerAdType.firstBanner:
        return AdConfig.firstBannerAdUnitId;
      case BannerAdType.secondBanner:
        return AdConfig.secondBannerAdUnitId;
      case BannerAdType.thirdBanner:
        return AdConfig.thirdBannerAdUnitId;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadAd() async {
    await _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner, // İki banner da aynı boyutta ise
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _bannerAd = null;
            });
          }
        },
      ),
    );

    try {
      await _bannerAd!.load();
    } on Exception {
      if (mounted) {
        setState(() {
          _isLoaded = false;
          _bannerAd = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return SizedBox(
        width: widget.width ?? _bannerAd!.size.width.toDouble(),
        height: widget.height ?? _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    return SizedBox(
      height: widget.height ?? 50,
      width: widget.width ?? 320,
    );
  }
}
