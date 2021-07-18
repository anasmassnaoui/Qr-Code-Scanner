import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/favorite_page.dart';
import 'package:qr_code_scanner_app/history_page.dart';
import 'package:qr_code_scanner_app/qr_code.dart';
import 'package:qr_code_scanner_app/qrcode_generator_page.dart';
import 'package:qr_code_scanner_app/qrcode_scanner_page.dart';
import 'package:qr_code_scanner_app/settings_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner_app/utils/admob_ids.dart';
import 'package:qr_code_scanner_app/utils/boxes.dart';
import 'package:qr_code_scanner_app/utils/tap_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<QrCodeHolder>(QrCodeHolderAdapter());
  await Hive.openBox<QrCodeHolder>(historyBox);
  await Hive.openBox(settingsBox);
  Admob.initialize();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr code scanner barcode Pro',
      theme: ThemeData(
        primaryColor: Colors.purple,
        primaryColorDark: Colors.purple,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool showBanner = false;
  bool loading = true;
  TabController controller;

  Widget buildBody() {
    final children = [
      QrCode(),
      History(),
      Favourite(),
      Settings(),
      QrCodeGenerator(),
      QrCodeScanner(),
    ];
    return children[index];
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() => registerTap(() => setState(() {})));
    (() async {
      await Admob.requestTrackingAuthorization();
      showInterstitial(() => setState(() => loading = false));
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(
        backgroundColor: Color(0xfff7f7f7),
        body: Center(
          child: Image.asset("assets/ic_qr.jpg"),
        ),
      );
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.purple,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Qr Code Scanner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.purple,
            height: 50,
            child: TabBar(
              controller: controller,
              tabs: [
                Text("Scanner"),
                Text("History"),
                Text("Settings"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                QrCode(),
                History(),
                Settings(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            maintainState: true,
            visible: showBanner,
            child: AdmobBanner(
              adUnitId: kReleaseMode ? bannerId : testBannerId,
              adSize: AdmobBannerSize.FULL_BANNER,
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

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
