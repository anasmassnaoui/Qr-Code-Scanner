import 'package:admob_flutter/admob_flutter.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_app/qrcode_result.dart';
import 'package:qr_code_scanner_app/utils/admob_ids.dart';
import 'package:qr_code_scanner_app/utils/load_page.dart';
import 'package:qr_code_scanner_app/utils/boxes.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QrCodeScannerState();
}

class QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey key = GlobalKey(debugLabel: 'Qr');
  QRViewController qrViewController;
  bool showBanner = false;

  void setController(QRViewController controller) {
    if (qrViewController != null) return;
    Barcode _scanInfo;
    this.qrViewController = controller;
    qrViewController.scannedDataStream.listen((scanInfo) async {
      if (_scanInfo == null ||
          (_scanInfo.code != scanInfo.code &&
              _scanInfo.format != scanInfo.format &&
              _scanInfo.rawBytes != scanInfo.rawBytes)) {
        _scanInfo = scanInfo;
        await showResult(scanInfo);
        _scanInfo = null;
      }
    });
  }

  Future<void> showResult(Barcode scanInfo) async {
    Hive.box<QrCodeHolder>(historyBox).add(
      QrCodeHolder(
        data: scanInfo.code,
        dateTime: DateFormat('kk:mm dd-MM-yyyy').format(DateTime.now()),
      ),
    );
    if (Hive.box(settingsBox).get('vibration', defaultValue: true))
      Vibration.vibrate(duration: 200);
    if (Hive.box(settingsBox).get('sound', defaultValue: true))
      AudioCache().play("nice_notification.mp3");
    qrViewController.pauseCamera();
    await loadPage(context, QrCodeResult(scanInfo: scanInfo));
    qrViewController.resumeCamera();
  }

  void toggleCamera() => qrViewController.flipCamera();
  void toggleFlash() => qrViewController.toggleFlash();

  @override
  void dispose() {
    super.dispose();
    qrViewController.dispose();
  }

  @override
  void didUpdateWidget(covariant QrCodeScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    qrViewController.pauseCamera().then((_) => qrViewController.resumeCamera());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scaning"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.light_max),
            onPressed: toggleFlash,
          ),
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: toggleCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          QRView(
            key: key,
            overlay: QrScannerOverlayShape(),
            onQRViewCreated: (controller) => setController(controller),
          ),
        ],
      ),
      bottomSheet: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            maintainState: true,
            visible: showBanner,
            child: AdmobBanner(
              adUnitId: kReleaseMode ? bannerId : testBannerId,
              adSize: AdmobBannerSize.BANNER,
              listener: (AdmobAdEvent event, _) {
                switch (event) {
                  case AdmobAdEvent.loaded:
                    setState(() => showBanner = true);
                    break;
                  case AdmobAdEvent.failedToLoad:
                    setState(() => showBanner = false);
                    break;
                  default:
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
