import 'package:qr_code_scanner_app/utils/admob_ids.dart';

int onTaps = 0;
int maxOnTaps = 5;

Future<T> registerTap<T>(T Function() onTap) {
  if (onTaps++ == maxOnTaps) {
    showInterstitial(() {
      onTap();
      onTaps = 0;
    });
  } else
    onTap();
  return Future.value();
}
