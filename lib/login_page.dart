import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './global_variable.dart';
import './main_page.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const APP_STORE_URL = "";
const PLAY_STORE_URL  =
    'https://play.google.com/store/apps/details?id=com.medicaline.myapplication&hl=en';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  final _formKey = GlobalKey<FormState>();
  Future<LoginInfo> futureLogin;
  @override
  void initState() {
      try {
        versionCheck(context);
      } catch (e) {
        print(e);
      }
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Center(child: (futureLogin == null) ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.white, Colors.blue.withOpacity(0.3)])),
            padding: EdgeInsets.all(20.0),
            child: Form(          // <= NEW
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 130.0,
                  child: Image.asset("assets/images/logo.png", fit: BoxFit.contain,),
                ),
                SizedBox(height: 10.0,),
                TextFormField(
                    onSaved: (value) => studNo = value,    // <= NEW
                    keyboardType: TextInputType.number,
                    style: style,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        hintText: "رقم الطالب الأكاديمي",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)
                        )
                    )
                ),
                SizedBox(height: 10.0,),
                TextFormField(
                    onSaved: (value) => passNo = value,    // <= NEW
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: style,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        hintText: "رقم البطاقة الشخصية",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)
                        )
                    )
                ),
                SizedBox(height: 10,),
                Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                      child: Text("تسجيل الدخول",
                          textAlign: TextAlign.center,
                          style:
                          style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        final form = _formKey.currentState;
                        form.save();
                        if (form.validate()) {
                          setState(() {
                            futureLogin = fetchInfoLogin();
                          });
                        }
                      },
                    )
                )
              ]),
            ),
          )
              : FutureBuilder<LoginInfo>(
              future: futureLogin,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return showProgress();
                    }
                  case ConnectionState.active:
                    {
                      break;
                    }
                  case ConnectionState.done:
                    {
                      if (snapshot.hasData && snapshot.data.result == 1) {
                        studName = snapshot.data.studName;
                        loginStatus = snapshot.data.loginStatus;
                        markStatus = snapshot.data.markStatus;
                        feeStatus = snapshot.data.feeStatus;
                        return MainPage();
                      } else {
                        return LoginPage();
                      }
                      break;
                    }
                  case ConnectionState.none:
                    {
                      break;
                    }
                }

                return showProgress();//Center(child: CircularProgressIndicator());
              }
          )
          ),
        ));
  }
}

Future<LoginInfo> fetchInfoLogin() async {
  var myUrl = basicUrl +
      'ws_get_login_info.php?studNo=' +
      studNo +
      '&studPass=' +
      passNo;
  final response = await http.get(Uri.encodeFull(myUrl),headers: {"Accept" : "application/json"});
  if (response.statusCode == 200) {
    return LoginInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class LoginInfo {
  final String studName;
  final int loginStatus;
  final int markStatus;
  final int feeStatus;
  final int result;
  LoginInfo(
      {this.studName,
        this.loginStatus,
        this.markStatus,
        this.feeStatus,
        this.result});
  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      studName: json['data']['stud_name'],
      loginStatus: json['data']['login_status'],
      markStatus: json['data']['mark_status'],
      feeStatus: json['data']['fee_status'],
      result: json['success'],
    );
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);

versionCheck(context) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    remoteConfig.getString('force_update_current_version');
    double newVersion = double.parse(remoteConfig
        .getString('force_update_current_version')
        .trim()
        .replaceAll(".", ""));
    if (newVersion > currentVersion) {
      _showVersionDialog(context);
    }
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}

_showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "نسخة جديدة متوفرة";
      String message = "هل تود التحديث الآن؟";
      String btnLabel = "تحديث";
      String btnLabelCancel = "لاحقا";
      return Platform.isIOS
          ? new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text(btnLabel),
                onPressed: () => _launchURL(APP_STORE_URL),
              ),
              FlatButton(
                child: Text(btnLabelCancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )
          : new AlertDialog(
              title: Text(title),
              content: Text(message),
              shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(PLAY_STORE_URL),
                ),
                FlatButton(
                  child: Text(btnLabelCancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
          );
    },
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
