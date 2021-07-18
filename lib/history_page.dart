import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_app/qrcode_result.dart';
import 'package:qr_code_scanner_app/utils/admob_ids.dart';
import 'package:qr_code_scanner_app/utils/boxes.dart';
import 'package:qr_code_scanner_app/utils/extract_info.dart';
import 'package:qr_code_scanner_app/utils/load_page.dart';
import 'package:qr_code_scanner_app/utils/tap_tracker.dart';
import 'package:qr_code_scanner_app/widgets/card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool showBanner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<QrCodeHolder>(historyBox).listenable(),
          builder: (_, Box<QrCodeHolder> box, __) {
            return Column(children: [
              Visibility(
                visible: showBanner,
                maintainState: true,
                child: TopCard(
                  child: AdmobBanner(
                    adUnitId: kReleaseMode ? bannerId : testBannerId,
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
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
              ),
              box.isEmpty
                  ? Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No Qr Code Scanned Yet"),
                        ),
                      ),
                    )
                  : CardList(
                      items: box
                          .toMap()
                          .map((key, qrCodeHolder) {
                            Data data = extractInfo(qrCodeHolder.data);
                            return MapEntry(
                              key,
                              ListItem(
                                  icon: Icon(data.icon),
                                  title: data.type,
                                  subTitle: qrCodeHolder.dateTime,
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => box.delete(key),
                                    )
                                  ],
                                  onTap: () => registerTap(
                                        () => loadPage(
                                          context,
                                          QrCodeResult(
                                            scanInfo: Barcode(
                                              qrCodeHolder.data,
                                              BarcodeFormat.qrcode,
                                              [],
                                            ),
                                          ),
                                        ),
                                      )),
                            );
                          })
                          .values
                          .toList()
                          .reversed
                          .toList(),
                    ),
            ]);
          },
        ),
      ),
    );
  }
}
