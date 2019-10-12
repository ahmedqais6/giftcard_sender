import 'applocalizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String cardType = 'Zain';
String cardAmount = 'IQD 1000';
String defaultMessageType = 'Regular';
String clearTextFeild = "";

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cardCodeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController mailtoController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  List<String> cardList = ['Zain', 'Asia', 'Korek', 'Switch'];
  List<String> amountList = ['IQD 1000', 'IQD 2000', 'IQD 3000', 'IQD 4000'];
  List<String> messageType = ['Regular', 'Specific'];
  final ContactPicker _contactPickerBusinessLogin = new ContactPicker();

  @override
  initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  TabController _tabController;

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(
        phone: "+964${phoneNumberController.text}",
        message:
            " Your Card Type is: $cardType \n Your Card Amount is: $cardAmount \n Card Code is: ${cardCodeController.text} \n Note: ${noteController.text}");
  }

  void getContactPhoneNubmer(context) async {
    Contact contact = await _contactPickerBusinessLogin.selectContact();
    String tempPhoneNumber = contact.phoneNumber.number;
    tempPhoneNumber = tempPhoneNumber
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(" ", "")
        .replaceAll("-", "")
        .replaceAll("+ 964", "0")
        .replaceAll(RegExp(r'\+964'), "0");
    phoneNumberController.text = tempPhoneNumber;
  }

  smsOpen() async {
    String uri =
        'sms:+964${phoneNumberController.text}?body= Your Card Type is: $cardType \n Your Card Amount is: $cardAmount \n Card Code is: ${cardCodeController.text} \n Note: ${noteController.text}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  emailOpen() async {
    var url =
        'mailto:${mailtoController.text}?subject=${subjectController.text}&body= Your Card Type is: $cardType \n Your Card Amount is: $cardAmount \n Card Code is: ${cardCodeController.text} \n Note: ${noteController.text}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chat),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Send")
                ],
              ),
            ),
            Tab(
             child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_balance_wallet),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Transaction")
                ],
              ),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
        title: Text(AppLocalizations.of(context).translate('appbar')),
        actions: <Widget>[
          FlatButton(
            onPressed: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Center(
                      child: Text(
                        AppLocalizations.of(context).translate('app_info'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('app_info_body'),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: OutlineButton(
                              onPressed: () => Navigator.of(context).pop(),
                              color: Colors.red,
                              child: Text(
                                AppLocalizations.of(context).translate('back'),
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15),
                              ),
                              borderSide: BorderSide(color: Colors.lightBlue),
                              shape: StadiumBorder()),
                        )
                      ],
                    ),
                  );
                }),
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          children: [
            ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          size: 70,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('app_header'),
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          labelText: AppLocalizations.of(context)
                              .translate('enter_phone_number'),
                          hintText: "07xxxxxxxxx",
                          suffixText: AppLocalizations.of(context)
                              .translate('choose_contact'),
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),

                            child: IconButton(
                              icon: Icon(Icons.contacts),
                              onPressed: () {
                                getContactPhoneNubmer(context);
                              },
                            ), // myIcon is a 48px-wide widget.
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (String cardCodeController) {
                        this.setState(() {
                          cardCodeController = cardCodeController;
                        });
                      },
                      controller: cardCodeController,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          labelText: AppLocalizations.of(context)
                              .translate('enter_card_code'),
                          hintText: "XXXX-XXXX-XXXX",
                          suffixText:
                              AppLocalizations.of(context).translate('clear'),
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),

                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                cardCodeController.text = clearTextFeild;
                              },
                            ), // myIcon is a 48px-wide widget.
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (String noteController) {
                        this.setState(() {
                          noteController = noteController;
                        });
                      },
                      controller: noteController,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          labelText: AppLocalizations.of(context)
                              .translate('add_note_optional'),
                          suffixText:
                              AppLocalizations.of(context).translate('clear'),
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),

                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                noteController.text = clearTextFeild;
                              },
                            ), // myIcon is a 48px-wide widget.
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: cardType,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      iconSize: 24,
                      onChanged: (String newValue) {
                        setState(() {
                          cardType = newValue;
                        });
                      },
                      items:
                          cardList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    DropdownButton<String>(
                      value: cardAmount,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      iconSize: 24,
                      onChanged: (String newValue) {
                        setState(() {
                          cardAmount = newValue;
                        });
                      },
                      items: amountList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    DropdownButton<String>(
                      value: defaultMessageType,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      iconSize: 24,
                      onChanged: (String newValue) {
                        setState(() {
                          defaultMessageType = newValue;
                        });
                      },
                      items: messageType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SelectableText(
                      "${AppLocalizations.of(context).translate('your_card_type')}"
                      " $cardType \n"
                      "${AppLocalizations.of(context).translate('your_card_amount')}"
                      " $cardAmount \n"
                      "${AppLocalizations.of(context).translate('card_code')}"
                      " ${cardCodeController.text} \n "
                      "${AppLocalizations.of(context).translate('note')}"
                      " ${noteController.text}",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('hint_text'),
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                        onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('email_button'),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: mailtoController,
                                      keyboardType: TextInputType.text,
                                      decoration: new InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(14.0),
                                            ),
                                          ),
                                          labelText: AppLocalizations.of(context)
                                              .translate('mailto'),
                                          hintText: "email@email.com",

                                          //suffixText: "Clear",

                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.only(
                                                    end: 12.0),

                                            child: IconButton(
                                              icon: Icon(Icons.cancel),
                                              onPressed: () {
                                                mailtoController.text =
                                                    clearTextFeild;
                                              },
                                            ), // myIcon is a 48px-wide widget.
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: subjectController,
                                      keyboardType: TextInputType.text,
                                      decoration: new InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14.0),
                                          ),
                                        ),

                                        labelText: AppLocalizations.of(context)
                                            .translate('subject'),

                                        hintText: AppLocalizations.of(context)
                                            .translate('email_hinttext'),

                                        // suffixText: "Clear",

                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 12.0),

                                          child: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () {
                                              subjectController.text =
                                                  clearTextFeild;
                                            },
                                          ), // myIcon is a 48px-wide widget.
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        OutlineButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            color: Colors.red,
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('back'),
                                              style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15),
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.lightBlue),
                                            shape: StadiumBorder()),
                                        OutlineButton(
                                            onPressed: () => emailOpen(),
                                            color: Colors.red,
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('send_email_button'),
                                              style: TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15),
                                            ),
                                            borderSide:
                                                BorderSide(color: Colors.purple),
                                            shape: StadiumBorder()),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                        color: Colors.red,
                        child: Text(
                          AppLocalizations.of(context).translate('email_button'),
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        borderSide: BorderSide(color: Colors.purple),
                        shape: StadiumBorder()),
                    SizedBox(
                      width: 30,
                    ),
                    OutlineButton(
                        onPressed: () {
                          if (phoneNumberController.text.isEmpty) {
                            return showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    title: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('alert'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'phone_number_field_empty'),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: OutlineButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              color: Colors.red,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('ok'),
                                                style: TextStyle(
                                                    color: Colors.lightBlue,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.lightBlue),
                                              shape: StadiumBorder()),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else if (cardCodeController.text.isEmpty) {
                            return showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    title: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('alert'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'card_number_field_empty'),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: OutlineButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              color: Colors.red,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('ok'),
                                                style: TextStyle(
                                                    color: Colors.lightBlue,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.lightBlue),
                                              shape: StadiumBorder()),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            whatsAppOpen();
                          }
                        },
                        color: Colors.red,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('whatsapp_button'),
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        borderSide: BorderSide(color: Colors.green),
                        shape: StadiumBorder()),
                    SizedBox(
                      width: 30,
                    ),
                    OutlineButton(
                        onPressed: () => smsOpen(),
                        color: Colors.red,
                        child: Text(
                          AppLocalizations.of(context).translate('sms_button'),
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        borderSide: BorderSide(color: Colors.orange),
                        shape: StadiumBorder()),
                  ],
                ),
                Divider(
                  height: 30,
                ),
              ],
            ),
            ListView(
              children: <Widget>[Text("data")],
            )
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
