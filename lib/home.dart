import 'package:shared_preferences/shared_preferences.dart';
import 'applocalizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String cardType = 'Amazon';
String cardAmount = '\$5';
String cardReagion = 'Region All';
String clearTextFeild = "";

String sentViaWhatsapp = "Sent via Whatsapp 💚";
String sentViaEmail = "Sent via Email 📬";
String sentViaSms = "Sent via SMS 💌";
String sentMethod = "";

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final phoneNumberController = TextEditingController();
  final cardCodeController = TextEditingController();
  final noteController = TextEditingController();
  final mailtoController = TextEditingController();
  final subjectController = TextEditingController();
  final pinNumberController = TextEditingController();

  final clearCasheFormKey = GlobalKey<FormState>();
  final phoneNumberFormKey = GlobalKey<FormState>();
  final cardCodeFormKey = GlobalKey<FormState>();
  final mailtoFormKey = GlobalKey<FormState>();
  final emailSubjectFormKey = GlobalKey<FormState>();

  List<String> cardList = [
    'Amazon',
    'Steam Wallet',
    'iTunes',
    'Google Play',
    'PSN',
    'xBox Live',
    'Razer Gold',
    'EA Acces'
  ];
  List<String> amountList = [
    '\$5',
    '\$10',
    '\$15',
    '\$20',
    '\$25',
    '\$30',
    '\$50',
    '\$100'
  ];
  List<String> regionType = ['Region All', 'USA', 'EU', 'UAE'];
  final ContactPicker _contactPickerBusinessLogin = new ContactPicker();
  TabController _tabController;

  @override
  initState() {
    checkConnectivity();
    _tabController = TabController(length: 2, vsync: this);
    // Shared Preference TODO
    getPhoneControllerData().then(phoneControllerTrans);
    getCardTypeData().then(cardTypeTrans);
    getCardAmountData().then(cardAmountTrans);
    getCardControllerData().then(cardControllerTrans);
    getNoteControllerPrefeData().then(noteControllerTrans);
    getDatePrefeData().then(getDateTrans);
    getCardRegionPrefeData().then(getCardRegionTrans);
    getSentMethodPrefeData().then(getSentMethodTrans);
    getMailtoControllerPrefeData().then(mailtoControllerTrans);
    getDateForCashePrefeData().then(getDateForCasheTrans);
    super.initState();
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

  void emailOpen() async {
    var url =
        "mailto:${mailtoController.text}?subject=${subjectController.text}&body="
        "Your Card Type is: $cardType"
        "\nYour Card Amount is: $cardAmount"
        "\nCard Code is: ${cardCodeController.text}"
        "\nCard Reagion: $cardReagion"
        "\nNote: ${noteController.text}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(
        phone: "+964${phoneNumberController.text}",
        message: "Your Card Type is: $cardType"
            "\nYour Card Amount is: $cardAmount"
            "\nCard Code is: ${cardCodeController.text}"
            "\nCard Reagion: $cardReagion"
            "\nNote: ${noteController.text}");
  }

  void smsOpen() async {
    String uri = "sms:+964${phoneNumberController.text}?body="
        "Your Card Type is: $cardType"
        "\nYour Card Amount is: $cardAmount"
        "\nCard Code is: ${cardCodeController.text}"
        "\nCard Reagion: $cardReagion"
        "\nNote: ${noteController.text}";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void openWiFiSetting() {
    AppSettings.openWIFISettings();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Flushbar(
        mainButton: FlatButton(
          onPressed: () => openWiFiSetting(),
          child: Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('open_wifi'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ],
          ),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message: AppLocalizations.of(context).translate('no_network'),
        icon: Icon(
          Icons.signal_wifi_off,
          size: 28.0,
          color: Colors.red[300],
        ),
        duration: Duration(seconds: 6),
      )..show(context);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message: AppLocalizations.of(context).translate('connected_mobiledata'),
        icon: Icon(
          Icons.wifi_tethering,
          size: 28.0,
          color: Colors.green[300],
        ),
        duration: Duration(seconds: 3),
      )..show(context);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message: AppLocalizations.of(context).translate('connected_wifi'),
        icon: Icon(
          Icons.wifi,
          size: 28.0,
          color: Colors.green[300],
        ),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  noNetworkChecker() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Flushbar(
        mainButton: FlatButton(
          onPressed: () => openWiFiSetting(),
          child: Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('open_wifi'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ],
          ),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message: AppLocalizations.of(context).translate('no_network'),
        icon: Icon(
          Icons.signal_wifi_off,
          size: 28.0,
          color: Colors.red[300],
        ),
        duration: Duration(seconds: 6),
      )..show(context);
    }
  }

  refreshPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

// Shared Preferences start here.

  Future<String> saveDataForCashe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('getDateForCashePrefeValue', "$getDateForCashe");
    return "Data Saved";
  }

  Future<String> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'phoneControllerPrefeValue', "${phoneNumberController.text}");
    prefs.setString('cardTypePrefeValue', "$cardType");
    prefs.setString('cardAmountPrefeValue', "$cardAmount");
    prefs.setString('cardControllerPrefeValue', "${cardCodeController.text}");
    prefs.setString('noteControllerPrefeValue', "${noteController.text}");
    prefs.setString('getDatePrefeValue', "$getDate");
    prefs.setString('cardReagionPrefeValue', "$cardReagion");
    prefs.setString('sentMethodPrefeValue', "$sentMethod");
    prefs.setString('mailtoControllerPrefeValue', "${mailtoController.text}");
    return "Data Saved";
  }

  Future<String> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phoneControllerPrefeValue");
    prefs.remove("cardTypePrefeValue");
    prefs.remove("cardAmountPrefeValue");
    prefs.remove("cardControllerPrefeValue");
    prefs.remove("noteControllerPrefeValue");
    prefs.remove("getDatePrefeValue");
    prefs.remove("cardReagionPrefeValue");
    prefs.remove("sentMethodPrefeValue");
    prefs.remove("mailtoControllerPrefeValue");
    return "Data Removed";
  }

  Future<String> getPhoneControllerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneControllerPrefeValue =
        prefs.getString('phoneControllerPrefeValue');
    return phoneControllerPrefeValue;
  }

  Future<String> getCardTypeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardTypePrefeValue = prefs.getString('cardTypePrefeValue');
    return cardTypePrefeValue;
  }

  Future<String> getCardAmountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardAmountPrefeValue = prefs.getString('cardAmountPrefeValue');
    return cardAmountPrefeValue;
  }

  Future<String> getCardControllerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardControllerPrefeValue =
        prefs.getString('cardControllerPrefeValue');
    return cardControllerPrefeValue;
  }

  Future<String> getNoteControllerPrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String noteControllerPrefeValue =
        prefs.getString('noteControllerPrefeValue');
    return noteControllerPrefeValue;
  }

  Future<String> getDatePrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getDatePrefeValue = prefs.getString('getDatePrefeValue');
    return getDatePrefeValue;
  }

  Future<String> getCardRegionPrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardReagionPrefeValue = prefs.getString('cardReagionPrefeValue');
    return cardReagionPrefeValue;
  }

  Future<String> getSentMethodPrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sentMethodPrefeValue = prefs.getString('sentMethodPrefeValue');
    return sentMethodPrefeValue;
  }

  Future<String> getMailtoControllerPrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mailtoControllerPrefeValue =
        prefs.getString('mailtoControllerPrefeValue');
    return mailtoControllerPrefeValue;
  }

  Future<String> getDateForCashePrefeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getDateForCashePrefeValue =
        prefs.getString('getDateForCashePrefeValue');
    return getDateForCashePrefeValue;
  }

  String getDate = (DateFormat.yMd().add_jm().format(DateTime.now()));
  String getDateForCashe = (DateFormat.yMd().add_jm().format(DateTime.now()));
  String getDatePrefe;
  String getDateForCashePrefe;
  String phoneControllerPrefe;
  String cardTypePrefe;
  String cardAmountPrefe;
  String cardControllerPrefe;
  String noteControllerPrefe;
  String cardReagionPrefe;
  String sentMethodPrefe;
  String mailtoPrefe;

  void phoneControllerTrans(String phoneControllerPrefeValue) {
    setState(() {
      phoneControllerPrefe = phoneControllerPrefeValue;
      if (phoneControllerPrefe == null) {
        phoneControllerPrefe = clearTextFeild;
      } else {
        phoneControllerPrefe = phoneControllerPrefeValue;
      }
    });
  }

  void cardTypeTrans(String cardTypePrefeValue) {
    setState(() {
      cardTypePrefe = cardTypePrefeValue;
      if (cardTypePrefe == null) {
        cardTypePrefe = clearTextFeild;
      } else {
        cardTypePrefe = cardTypePrefeValue;
      }
    });
  }

  void cardAmountTrans(String cardAmountPrefeValue) {
    setState(() {
      cardAmountPrefe = cardAmountPrefeValue;
      if (cardAmountPrefe == null) {
        cardAmountPrefe = clearTextFeild;
      } else {
        cardAmountPrefe = cardAmountPrefeValue;
      }
    });
  }

  void cardControllerTrans(String cardControllerPrefeValue) {
    setState(() {
      cardControllerPrefe = cardControllerPrefeValue;
      if (cardControllerPrefe == null) {
        cardControllerPrefe = clearTextFeild;
      } else {
        cardControllerPrefe = cardControllerPrefeValue;
      }
    });
  }

  void noteControllerTrans(String noteControllerPrefeValue) {
    setState(() {
      noteControllerPrefe = noteControllerPrefeValue;
      if (noteControllerPrefe == null) {
        noteControllerPrefe = clearTextFeild;
      } else {
        noteControllerPrefe = noteControllerPrefeValue;
      }
    });
  }

  void getDateTrans(String getDatePrefeValue) {
    setState(() {
      getDatePrefe = getDatePrefeValue;
      if (getDatePrefe == null) {
        getDatePrefe = clearTextFeild;
      } else {
        getDatePrefe = getDatePrefeValue;
      }
    });
  }

  void getCardRegionTrans(String getCardRegionPrefeData) {
    setState(() {
      cardReagionPrefe = getCardRegionPrefeData;
      if (cardReagionPrefe == null) {
        cardReagionPrefe = clearTextFeild;
      } else {
        cardReagionPrefe = getCardRegionPrefeData;
      }
    });
  }

  void getSentMethodTrans(String getSentMethodPrefeData) {
    setState(() {
      sentMethodPrefe = getSentMethodPrefeData;
      if (sentMethodPrefe == null) {
        sentMethodPrefe = clearTextFeild;
      } else {
        sentMethodPrefe = getSentMethodPrefeData;
      }
    });
  }

  void mailtoControllerTrans(String mailtoControllerPrefeValue) {
    setState(() {
      mailtoPrefe = mailtoControllerPrefeValue;
      if (mailtoPrefe == null) {
        mailtoPrefe = clearTextFeild;
      } else {
        mailtoPrefe = mailtoControllerPrefeValue;
      }
    });
  }

  void getDateForCasheTrans(String getDateForCashePrefeValue) {
    setState(() {
      getDateForCashePrefe = getDateForCashePrefeValue;
      if (getDateForCashePrefe == null) {
        getDateForCashePrefe = clearTextFeild;
      } else {
        getDateForCashePrefe = getDateForCashePrefeValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // to remove back button.
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
                  Text(AppLocalizations.of(context).translate('send'))
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
                  Text(AppLocalizations.of(context).translate('transaction'))
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
                        Image.asset(
                          "assets/icon/icon.png",
                          height: 100,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${AppLocalizations.of(context).translate('app_header')}" +
                              " v1.0.0",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                        ),
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
          controller: _tabController,
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
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: phoneNumberFormKey,
                      child: TextFormField(
                        onChanged: (String phoneNumberController) {
                          this.setState(() {
                            phoneNumberController = phoneNumberController;
                          });
                        },
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
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: IconButton(
                                icon: Icon(Icons.contacts),
                                onPressed: () {
                                  getContactPhoneNubmer(context);
                                },
                              ),
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('validat_phone_number_field_empty');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: cardCodeFormKey,
                      child: TextFormField(
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
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  cardCodeController.text = clearTextFeild;
                                },
                              ),
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('validat_card_number_field_empty');
                          }
                          return null;
                        },
                      ),
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
                            padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                noteController.text = clearTextFeild;
                              },
                            ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      items: cardList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                    DropdownButton<String>(
                      value: cardReagion,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      iconSize: 24,
                      onChanged: (String newValue) {
                        setState(() {
                          cardReagion = newValue;
                        });
                      },
                      items: regionType
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
                  height: 20,
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
                      "${AppLocalizations.of(context).translate('card_reagion')}"
                      " $cardReagion \n"
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
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());

                        if (cardCodeController.text.isEmpty) {
                          cardCodeFormKey.currentState.validate();
                        } else if (connectivityResult ==
                            ConnectivityResult.none) {
                          Flushbar(
                            mainButton: FlatButton(
                              onPressed: () => openWiFiSetting(),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('open_wifi'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            flushbarPosition: FlushbarPosition.TOP,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            message: AppLocalizations.of(context)
                                .translate('no_network'),
                            icon: Icon(
                              Icons.signal_wifi_off,
                              size: 28.0,
                              color: Colors.red[300],
                            ),
                            duration: Duration(seconds: 6),
                          )..show(context);
                        } else {
                          showDialog(
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Form(
                                        key: mailtoFormKey,
                                        child: TextFormField(
                                          controller: mailtoController,
                                          keyboardType: TextInputType.text,
                                          decoration: new InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(14.0),
                                                ),
                                              ),
                                              labelText:
                                                  AppLocalizations.of(context)
                                                      .translate('mailto'),
                                              hintText: "email@email.com",
                                              suffixIcon: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(end: 12.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  onPressed: () {
                                                    mailtoController.text =
                                                        clearTextFeild;
                                                  },
                                                ),
                                              )),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .translate('validat_mailto');
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: emailSubjectFormKey,
                                        child: TextFormField(
                                          controller: subjectController,
                                          keyboardType: TextInputType.text,
                                          decoration: new InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(14.0),
                                              ),
                                            ),
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate('subject'),
                                            hintText: AppLocalizations.of(
                                                    context)
                                                .translate('email_hinttext'),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(end: 12.0),
                                              child: IconButton(
                                                icon: Icon(Icons.cancel),
                                                onPressed: () {
                                                  subjectController.text =
                                                      clearTextFeild;
                                                },
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .translate('validat_subject');
                                            }
                                            return null;
                                          },
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
                                              onPressed: () {
                                                if (mailtoController
                                                        .text.isEmpty ||
                                                    subjectController
                                                        .text.isEmpty) {
                                                  mailtoFormKey.currentState
                                                      .validate();
                                                  emailSubjectFormKey
                                                      .currentState
                                                      .validate();
                                                } else {
                                                  saveData();
                                                  sentMethod = sentViaEmail;
                                                  emailOpen();
                                                  Navigator.of(context).pop();
                                                  refreshPage();
                                                }
                                              },
                                              color: Colors.red,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'send_email_button'),
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.purple),
                                              shape: StadiumBorder()),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                      color: Colors.red,
                      child: Text(
                        AppLocalizations.of(context).translate('email_button'),
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      borderSide: BorderSide(color: Colors.purple),
                      shape: StadiumBorder(),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    OutlineButton(
                        onPressed: () async {
                          saveData();
                          sentMethod = sentViaWhatsapp;
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (phoneNumberController.text.isEmpty ||
                              cardCodeController.text.isEmpty) {
                            phoneNumberFormKey.currentState.validate();
                            cardCodeFormKey.currentState.validate();
                          } else if (connectivityResult ==
                              ConnectivityResult.none) {
                            Flushbar(
                              mainButton: FlatButton(
                                onPressed: () => openWiFiSetting(),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('open_wifi'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              flushbarPosition: FlushbarPosition.TOP,
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                              message: AppLocalizations.of(context)
                                  .translate('no_network'),
                              icon: Icon(
                                Icons.signal_wifi_off,
                                size: 28.0,
                                color: Colors.red[300],
                              ),
                              duration: Duration(seconds: 6),
                            )..show(context);
                          } else {
                            whatsAppOpen();
                            refreshPage();
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
                        onPressed: () {
                          saveData();
                          sentMethod = sentViaSms;
                          if (phoneNumberController.text.isEmpty ||
                              cardCodeController.text.isEmpty) {
                            phoneNumberFormKey.currentState.validate();
                            cardCodeFormKey.currentState.validate();
                          } else {
                            smsOpen();
                            refreshPage();
                          }
                        },
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
              ],
            ),
            ListView(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SelectableText(
                          "${AppLocalizations.of(context).translate('customer_phone_number')}"
                          " $phoneControllerPrefe\n"
                          "${AppLocalizations.of(context).translate('customer_email')}"
                          " $mailtoPrefe\n\n"
                          "${AppLocalizations.of(context).translate('your_card_type')}"
                          " $cardTypePrefe \n"
                          "${AppLocalizations.of(context).translate('your_card_amount')}"
                          " $cardAmountPrefe \n"
                          "${AppLocalizations.of(context).translate('card_code')}"
                          " $cardControllerPrefe \n"
                          "${AppLocalizations.of(context).translate('card_reagion')}"
                          " $cardReagionPrefe \n"
                          "${AppLocalizations.of(context).translate('note')}"
                          " $noteControllerPrefe",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "$sentMethodPrefe\n$getDatePrefe",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                        onPressed: () {
                          showDialog(
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
                                        AppLocalizations.of(context)
                                            .translate('pin_message'),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Form(
                                        key: clearCasheFormKey,
                                        child: TextFormField(
                                          onChanged:
                                              (String pinNumberController) {
                                            this.setState(() {
                                              pinNumberController =
                                                  pinNumberController;
                                            });
                                          },
                                          controller: pinNumberController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 4,
                                          decoration: new InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(14.0),
                                              ),
                                            ),
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate('pin_enter'),
                                            hintText: "XXXX",
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .translate('validat_pin');
                                            }
                                            return null;
                                          },
                                        ),
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
                                              onPressed: () {
                                                setState(() {
                                                  clearCasheFormKey.currentState
                                                      .validate();
                                                  if (pinNumberController
                                                          .text ==
                                                      "0000") {
                                                    saveDataForCashe();
                                                    removeData();
                                                    pinNumberController.text =
                                                        "";
                                                    refreshPage();
                                                  }
                                                });
                                              },
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
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        color: Colors.red,
                        child: Text(
                          AppLocalizations.of(context).translate('clear_cashe'),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        borderSide: BorderSide(color: Colors.blueAccent),
                        shape: StadiumBorder()),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${AppLocalizations.of(context).translate('last_cashe_clear')}"
                  "\n$getDateForCashePrefe",
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
