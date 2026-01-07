import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  // BannerAd
  static BannerAd? myBanner;
  static AdWidget? adWidget;

  static InterstitialAd? interstitialAd;
  static int numInterstitialLoadAttempts = 0;

  static bool loadingAnchoredBanner = false;
  static const int maxFailedLoadAttempts = 3;

  static Future<void> createAnchoredBanner(
      BuildContext context, BannerAdListener bannerAdListener, String adsId) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    myBanner = BannerAd(
      adUnitId: adsId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: bannerAdListener,
    );
    return myBanner!.load();
  }

  static void createInterstitialAd({required String adsId}) {
    InterstitialAd.load(
        adUnitId: adsId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd(adsId: adsId);
            }
          },
        ));
  }

  static void showInterstitialAd({required String adsId}) {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd(adsId: adsId);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd(adsId: adsId);
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  static String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2692469317826110/4296890542';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2692469317826110/9892562658';
    }
    return null;
  }

  static String? getWidgetPressedInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2692469317826110/4027112011';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2692469317826110/8760563941';
    }
    return null;
  }
  static String? getCategoryButtonPressedInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2692469317826110/6461703662';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2692469317826110/7306197265';
    }
    return null;
  }
  static String? getFavouritePageInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2692469317826110/1209376985';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2692469317826110/6106480449';
    }
    return null;
  }

  static String? getNativeAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2692469317826110/7043323449';
    }
    return null;
  }
}
