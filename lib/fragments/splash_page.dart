import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/fragments/HomeScreen.dart';
import 'package:registerBook/fragments/admin_name_page.dart';
import 'package:registerBook/fragments/login_page.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:registerBook/stores/login_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  @override
  void initState() {
    super.initState();
    checkConnection(context);
  }

  void _showDialog(
      String title, String content, BuildContext context, bool isConnect) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("err"),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      if (isConnect) {
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: new Text("Close"))
              ]);
        });
  }

  checkConnection(BuildContext context) async {
    // print("AMit");
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          InternetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          Provider.of<LoginStore>(context, listen: false)
              .isAlreadyAuthenticated()
              .then((result) async {
            if (result) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              final adminName = preferences.getString('adminName');
              print(adminName);
              if (adminName != null) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => AdminName()),
                    (Route<dynamic> route) => false);
              }
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
            }
          });
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(InternetStatus, contentmessage, context, false);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
    );
  }
}
