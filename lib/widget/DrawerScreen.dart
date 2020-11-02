import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/add_event.dart';
import 'package:registerBook/fragments/book_vadi.dart';
import 'package:registerBook/fragments/add_vadi.dart';
import 'package:registerBook/fragments/event_list_screen.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:registerBook/stores/login_store.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List<Vadi> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      list = Provider.of<FirebaseMethods>(context, listen: false).vadiList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          // decoration: BoxDecoration(
          //   color: appStore.appBarColor,
          // ),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.power_settings_new,
                  //       color: primaryColor,
                  //     ),
                  //     onPressed: () {
                  //       LoginStore().signOut(context);
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: primaryColor),
                      image: DecorationImage(
                          image: AssetImage('assets/img/logo.jpg')),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Mandap Decoration",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                  // Text("JohnDoe@gmail.com",
                  //     style: TextStyle(color: primaryColor, fontSize: 16.0)),
                  30.height,
                  // itemList(Icon(Icons.home, color: primaryColor), "Home"),
                  Divider(),
                  15.height,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VadiBookingForm()));
                    },
                    child: itemList(
                        Icon(Icons.add, color: primaryColor), "Add vadi"),
                  ),
                  list.length == 0 ? Container() : Divider(),
                  list.length == 0 ? Container() : 15.height,
                  list.length == 0
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => BookVadi()));
                          },
                          child: itemList(
                              Icon(Icons.bookmark, color: primaryColor),
                              "Book Vadi"),
                        ),
                  Divider(),
                  15.height,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EventListScreen()));
                    },
                    child: itemList(
                        Icon(Icons.add_circle, color: primaryColor), "Events"),
                  ),
                  Divider(),
                  15.height,
                  GestureDetector(
                    onTap: () {
                      LoginStore().signOut(context);
                    },
                    child: itemList(
                        Icon(Icons.power_settings_new, color: primaryColor),
                        "Logout"),
                  ),
                  // Divider(),
                  // 15.height,
                  // itemList(
                  //     Icon(Icons.email, color: primaryColor), "Contact us"),
                  // Divider(),
                  // 15.height,
                  // itemList(
                  //     Icon(Icons.info_outline, color: primaryColor), "Help"),
                  // Divider(),
                  // 15.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemList(Widget icon, String title) {
    return Row(
      children: [
        icon,
        10.width,
        Text(title, style: TextStyle(color: primaryColor)),
      ],
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
