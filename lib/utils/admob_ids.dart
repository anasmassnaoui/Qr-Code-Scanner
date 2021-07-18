import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';

final String testBannerId = "ca-app-pub-3940256099942544/6300978111";
final String testInterstitialId = "ca-app-pub-3940256099942544/1033173712";
final String bannerId = "put your banner Id here";
final String interstitialId = "put your interstitial Id here";

void showInterstitial(Function callBack) {
  AdmobInterstitial admobInterstitial;
  admobInterstitial = AdmobInterstitial(
    adUnitId: kReleaseMode ? interstitialId : testInterstitialId,
    listener: (AdmobAdEvent event, _) async {
      switch (event) {
        case AdmobAdEvent.loaded:
          admobInterstitial.show();
          break;
        case AdmobAdEvent.closed:
          callBack();
          break;
        case AdmobAdEvent.failedToLoad:
          callBack();
          break;
        default:
      }
    },
  );
  admobInterstitial.load();
}
