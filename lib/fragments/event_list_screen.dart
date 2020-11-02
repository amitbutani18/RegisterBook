import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/CalendarScreen.dart';
import 'package:registerBook/fragments/add_event.dart';
import 'package:registerBook/fragments/add_vadi.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'edit_event_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<Color> colors = [appCat1, appCat2, appCat3];

  bool isInit = true, isload = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isload = true;
      });
      await Provider.of<FirebaseMethods>(context, listen: false)
          .getAndSetEvent();
      setState(() {
        isload = false;
      });
      isInit = false;
    }
  }

  BoxDecoration boxDecoration(
      {double radius = 2,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
    return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow
          ? [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  Widget text(var text,
      {var fontSize = 20,
      textColor = Colors.white,
      var fontFamily = 16,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.5}) {
    return Text(text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            // fontFamily: fontFamily,
            fontSize: 20,
            color: Colors.black,
            height: 1.5,
            letterSpacing: 1));
  }

  // Future<void> showNotification() async {
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL_ID',
  //     'CHANNEL_NAME',
  //     "CHANNEL_DESCRIPTION",
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     playSound: true,
  //     timeoutAfter: 5000,
  //     styleInformation: DefaultStyleInformation(true, true),
  //   );
  //   var iosChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics =
  //       NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Notification ID
  //     'Test Title', // Notification Title
  //     'Test Body', // Notification Body, set as null to remove the body
  //     platformChannelSpecifics,
  //     payload: 'New Payload', // Notification Payload
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print(_connectionStatus);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AddEvent()));
            }),
        key: _key,
        // drawer: DrawerScreen(),
        appBar: AppBar(
          // actions: [
          //   IconButton(icon: Icon(Icons.ac_unit), onPressed: showNotification)
          // ],
          // leading: Builder(
          //   builder: (BuildContext context) {
          //     return IconButton(
          //       icon: const Icon(Icons.menu),
          //       onPressed: () {
          //         _key.currentState.openDrawer();
          //       },
          //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          //     );
          //   },
          // ),
          backgroundColor: primaryColor,
          title: Text('Event List',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          automaticallyImplyLeading: false,
        ),
        body: isload
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Builder(builder: (BuildContext context) {
                var width = MediaQuery.of(context).size.width;
                var height = MediaQuery.of(context).size.height;

                return FutureBuilder(
                  future: Provider.of<FirebaseMethods>(context).getAndSetVadi(),
                  builder: (context, snap) => Consumer<FirebaseMethods>(
                    builder: (context, eventDetails, ch) => Container(
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: eventDetails.eventList.length == 0
                          ? Center(
                              child: Image.asset('assets/img/nodatafound.png'))
                          : AnimationLimiter(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: eventDetails.eventList.length,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final vadiId =
                                      eventDetails.eventList[index].id;
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      verticalOffset: height * 0.5,
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return EditEvent(
                                            event:
                                                eventDetails.eventList[index],
                                          );
                                        })),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16, bottom: 16),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  children: <Widget>[
                                                    Container(
                                                      width: width,
                                                      height: 80,
                                                      padding: EdgeInsets.only(
                                                          left: 16, right: 16),
                                                      margin: EdgeInsets.only(
                                                          right: width / 28),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              text(
                                                                  '${eventDetails.eventList[index].name}',
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontFamily:
                                                                      18,
                                                                  fontSize: 16,
                                                                  maxLine: 2),
                                                            ],
                                                          ).expand(),
                                                        ],
                                                      ),
                                                      decoration: boxDecoration(
                                                          bgColor: Colors.white,
                                                          radius: 4,
                                                          showShadow: true),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: Icon(Icons.edit,
                                                          color: appWhite),
                                                      decoration: BoxDecoration(
                                                          color: colors[index %
                                                              colors.length],
                                                          shape:
                                                              BoxShape.circle),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                );
              }));
  }
}
