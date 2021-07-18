import 'package:account_picker/account_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:qr_code_scanner_app/qr_code_viewer.dart';
import 'package:qr_code_scanner_app/utils/extract_info.dart';
import 'package:qr_code_scanner_app/utils/load_page.dart';
import 'package:qr_code_scanner_app/widgets/card.dart';

class FormData extends StatelessWidget {
  final Data data;

  const FormData({Key key, this.data}) : super(key: key);

  Widget buildBody() {
    switch (data.runtimeType) {
      case SmsData:
        return SmsFormData(data: data);
      case MailData:
        return MailFormData(data: data);
      case ContactData:
        return ContactFormData(data: data);
      case TeleData:
        return TeleFormData(data: data);
      case UrlData:
        return UrlFormData(data: data);
      default:
        return TextFormData(data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Qr Code for ${data.type}"),
      ),
      body: SingleChildScrollView(
        child: buildBody(),
      ),
    );
  }
}

class SmsFormData extends StatelessWidget {
  final Data data;
  String number = '';
  String message = '';

  SmsFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: number),
                onChanged: (value) => number = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Phone Number",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => FlutterContactPicker.pickPhoneContact()
                        .then((contact) =>
                            setState(() => number = contact.phoneNumber.number))
                        .catchError((e) => print('error')),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (value) => message = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  hintText: "Message...",
                ),
                maxLines: 4,
                maxLength: 1000,
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(data: SmsData(number: number, message: message)),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}

class MailFormData extends StatelessWidget {
  final Data data;
  String to = '';
  String subject = '';
  String body = '';

  MailFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: to),
                onChanged: (value) => to = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "To",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => AccountPicker.emailHint()
                        .then((account) => setState(() => to = account.email))
                        .catchError((e) => print(e)),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (value) => subject = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Subject",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (value) => body = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  hintText: "Message...",
                ),
                maxLines: 4,
                maxLength: 1000,
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(
                    data: MailData(to: to, subject: subject, body: body)),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}

class ContactFormData extends StatelessWidget {
  final Data data;
  String firstname = '';
  String lastname = '';
  String number = '';
  String email = '';
  String addrese = '';

  ContactFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => FlutterContactPicker.pickFullContact()
                        .then((contact) => setState(() {
                              firstname = contact.name.firstName ?? '';
                              firstname += contact.name.middleName ?? '';
                              lastname = contact.name.lastName ?? '';
                              number = contact.phones.isNotEmpty
                                  ? contact.phones.first?.number
                                  : '';
                              email = contact.emails.isNotEmpty
                                  ? contact.emails.first?.email
                                  : '';
                              addrese = contact.addresses.isNotEmpty
                                  ? contact.addresses.first?.region
                                  : '';
                            }))
                        .catchError((e) => print("error")))
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: firstname),
                onChanged: (value) => firstname = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "First Name",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: lastname),
                onChanged: (value) => lastname = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Last Name",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: number),
                onChanged: (value) => number = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Number",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: email),
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: addrese),
                onChanged: (value) => addrese = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  hintText: "Addresse",
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(
                    data: ContactData(
                  firstname: firstname,
                  lastname: lastname,
                  number: number,
                  email: email,
                  address: addrese,
                )),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}

class TeleFormData extends StatelessWidget {
  final Data data;
  String number = '';

  TeleFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: number),
                onChanged: (value) => number = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Phone Number",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => FlutterContactPicker.pickPhoneContact()
                        .then((contact) =>
                            setState(() => number = contact.phoneNumber.number))
                        .catchError((e) => print('error')),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(data: TeleData(number: number)),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}

class UrlFormData extends StatelessWidget {
  final Data data;
  String link = '';

  UrlFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: TextEditingController(text: link),
                onChanged: (value) => link = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  labelText: "Link",
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(data: UrlData(link)),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}

class TextFormData extends StatelessWidget {
  final Data data;
  String text = '';

  TextFormData({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(data.icon)),
                SizedBox(width: 10),
                Text(data.type),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                onChanged: (value) => text = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                  hintText: "Text...",
                ),
                maxLines: 4,
                maxLength: 1000,
              ),
            ),
            TextButton.icon(
              onPressed: () => loadPage(
                context,
                QrCodeViewer(data: Data(text)),
              ),
              icon: Icon(Icons.done),
              label: Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}
