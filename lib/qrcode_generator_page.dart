import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/formdata.dart';
import 'package:qr_code_scanner_app/utils/extract_info.dart';
import 'package:qr_code_scanner_app/utils/load_page.dart';
import 'package:qr_code_scanner_app/utils/tap_tracker.dart';
import 'package:qr_code_scanner_app/widgets/card.dart';

class QrCodeGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Qr Code"),
      ),
      body: CardList(
        items: [
          CardListItem(
            icon: Icon(Icons.sms),
            text: "Message",
            onTap: () =>
                registerTap(() => loadPage(context, FormData(data: SmsData()))),
          ),
          CardListItem(
            icon: Icon(Icons.mail),
            text: "Mail",
            onTap: () => registerTap(
                () => loadPage(context, FormData(data: MailData()))),
          ),
          CardListItem(
            icon: Icon(Icons.contact_page),
            text: "Contact",
            onTap: () => registerTap(
                () => loadPage(context, FormData(data: ContactData()))),
          ),
          CardListItem(
            icon: Icon(Icons.call),
            text: "Telephone",
            onTap: () => registerTap(
                () => loadPage(context, FormData(data: TeleData()))),
          ),
          CardListItem(
            icon: Icon(Icons.language),
            text: "Link",
            onTap: () => registerTap(
                () => loadPage(context, FormData(data: UrlData('')))),
          ),
          CardListItem(
            icon: Icon(Icons.description),
            text: "Text",
            onTap: () =>
                registerTap(() => loadPage(context, FormData(data: Data('')))),
          ),
        ],
      ),
    );
  }
}

class BoxGrid extends StatelessWidget {
  final Color color;
  final Widget icon;
  final String text;
  final void Function() onTap;

  const BoxGrid({
    Key key,
    this.color,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: color,
                foregroundColor: Colors.white,
                child: icon,
              ),
              SizedBox(
                height: 10,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
