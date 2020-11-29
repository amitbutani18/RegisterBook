import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/HomeScreen.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:registerBook/widget/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class BookVadi extends StatefulWidget {
  @override
  _BookVadiState createState() => _BookVadiState();
}

class _BookVadiState extends State<BookVadi> {
  TextEditingController nameTextEditingController = TextEditingController();

  TextEditingController adminNameTextEditingController;
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  TextEditingController otherMobileNumberTextEditingController =
      TextEditingController();
  TextEditingController eventDetailsTextEditingController =
      TextEditingController();
  TextEditingController notesTextEditingController = TextEditingController();
  TextEditingController bookingDateTextEditingController =
      TextEditingController(
          text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  TextEditingController eventDateTextEditingController =
      TextEditingController();

  TextEditingController billNumberTextEditingController =
      TextEditingController();

  bool _isLoad = false, _isInit = true;
  List<Vadi> _dropdownItems = [];
  List<Event> _eventDropdownItems = [];
  List<DropdownMenuItem<Vadi>> _dropdownMenuItems;
  List<DropdownMenuItem<Event>> _eventDropdownMenuItems;
  Vadi _selectedItem;
  Event _selectedEvent;
  String _eventDate, _adminName;
  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dropdownItems =
          Provider.of<FirebaseMethods>(context, listen: false).vadiList;
      _eventDropdownItems =
          Provider.of<FirebaseMethods>(context, listen: false).eventList;
    });
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _eventDropdownMenuItems = buildEventDropDownMenuItems(_eventDropdownItems);
    if (_dropdownMenuItems.length != 0) {
      _selectedItem = _dropdownMenuItems[0].value;
      _selectedEvent = _eventDropdownMenuItems[0].value;
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      setState(() {
        adminNameTextEditingController = TextEditingController(
            text: sharedPreferences.getString('adminName'));
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.access_alarm),
        //       onPressed: () async {
        //         final String serverToken =
        //             'AAAAZi0VGf8:APA91bEqLIOYgFdCFzFOFPC6FdTEBaNVZyV3een6hwuG_8DS1Aozajs_tSDOPhAIqR8yu1psvPRACadWdigBpSS1csVFi9b21r3tAxGMqWoo1rxqtYVhJlMFM9zxZ2ixAsYmmmKCydTz';

        //         final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

        //         await firebaseMessaging.requestNotificationPermissions(
        //           const IosNotificationSettings(
        //               sound: true,
        //               badge: true,
        //               alert: true,
        //               provisional: false),
        //         );
        //         final fcmTocken = await firebaseMessaging.getToken();
        //         await http.post(
        //           'https://fcm.googleapis.com/fcm/send',
        //           headers: <String, String>{
        //             'Content-Type': 'application/json',
        //             'Authorization': 'key=$serverToken',
        //           },
        //           body: jsonEncode(
        //             <String, dynamic>{
        //               'notification': <String, dynamic>{
        //                 'body': 'this is a body',
        //                 'title': 'this is a title'
        //               },
        //               'priority': 'high',
        //               'data': <String, dynamic>{
        //                 'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        //                 'id': '1',
        //                 'status': 'done'
        //               },
        //               'to':
        //                   'eMOuJddZQY-t9yjYjiVzMv:APA91bFAJJ9KvejaG7LeqWd_YBMx-crTbwKJ_IsbJ2fuSlDomgHSRxf3nq_2-OO5mPC4j6Mwuk-cRpzaYjJiG-3kgbFoL0yIIPKvDybciR82_I8QwEgBBf0ccPXZFb-HgSAq0l4XM3AE' //await firebaseMessaging.getToken(),
        //             },
        //           ),
        //         );
        //         final Completer<Map<String, dynamic>> completer =
        //             Completer<Map<String, dynamic>>();

        //         firebaseMessaging.configure(
        //           onMessage: (Map<String, dynamic> message) async {
        //             completer.complete(message);
        //           },
        //         );
        //         print(fcmTocken);
        //       })
        // ],
        title: Text('Booking form'),
        backgroundColor: primaryColor,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.all(0.0),
                    child: DropdownButton<Vadi>(
                        isExpanded: true,
                        value: _selectedItem,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value;
                          });
                        }),
                  ),
                  TextField(
                    controller: nameTextEditingController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: adminNameTextEditingController,
                    decoration: InputDecoration(labelText: 'Admin name'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: billNumberTextEditingController,
                    decoration: InputDecoration(labelText: 'Bill number'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    maxLines: null,
                    controller: addressTextEditingController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    controller: mobileNumberTextEditingController,
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                  ),
                  TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    controller: otherMobileNumberTextEditingController,
                    decoration:
                        InputDecoration(labelText: 'Other Contact Number'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay _currentTime = new TimeOfDay.now();
                      final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101));
                      time = await showTimePicker(
                        context: context,
                        initialTime: _currentTime,
                      );
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                          _eventDate = picked.toIso8601String();
                          eventDateTextEditingController.text =
                              DateFormat("dd/MM/yyyy").format(picked) +
                                  ' / ' +
                                  time.format(context);
                        });
                    },
                    child: TextField(
                      enabled: false,
                      controller: eventDateTextEditingController,
                      decoration: InputDecoration(labelText: 'Event Date'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: bookingDateTextEditingController,
                    decoration: InputDecoration(labelText: 'Booking Date'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(0.0),
                    child: DropdownButton<Event>(
                        isExpanded: true,
                        value: _selectedEvent,
                        items: _eventDropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedEvent = value;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    maxLines: null,
                    controller: eventDetailsTextEditingController,
                    decoration: InputDecoration(labelText: 'Event Details'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    maxLines: null,
                    controller: notesTextEditingController,
                    decoration: InputDecoration(labelText: 'Notes'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: _isLoad
                        ? Center(
                            child: LinearProgressIndicator(),
                          )
                        : RaisedButton(
                            onPressed: () {
                              if (validateField(context)) {
                                _submit();
                              }
                            },
                            color: primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      color: primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Vadi>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<Vadi>> items = List();
    for (Vadi listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Event>> buildEventDropDownMenuItems(List listItems) {
    print(listItems.length);
    List<DropdownMenuItem<Event>> items = List();
    for (Event listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  validateField(BuildContext context) {
    if (addressTextEditingController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter address', SnackBartype.nagetive);
      return false;
    }
    if (mobileNumberTextEditingController.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter mobile number', SnackBartype.nagetive);
      return false;
    }
    if (eventDateTextEditingController.text.isEmpty) {
      CustomSnackBar(
          context, 'Please choose event date', SnackBartype.nagetive);
      return false;
    }
    if (nameTextEditingController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter name', SnackBartype.nagetive);
      return false;
    }
    return true;
  }

  _submit() async {
    setState(() {
      _isLoad = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // DateTime eventDate =
    //     DateTime.parse(eventDateTextEditingController.text.split('/').first);
    // print(eventDate.toIso8601String());
    String vadiId = _selectedItem.id;
    try {
      await http.post(
          'https://registerbook-a5d27.firebaseio.com/Register/$vadiId.json',
          body: json.encode({
            'name': nameTextEditingController.text,
            'vadiName': _selectedItem.name,
            'adminName': adminNameTextEditingController.text,
            'billNumber': billNumberTextEditingController.text,
            'mobileNumber': mobileNumberTextEditingController.text,
            'otherMobile': otherMobileNumberTextEditingController.text,
            'eventDate': _eventDate,
            'evenTime': time.format(context),
            'address': addressTextEditingController.text,
            'bookingDate': DateTime.now().toIso8601String(),
            'eventDetails': eventDetailsTextEditingController.text,
            'notes': notesTextEditingController.text,
            'eventName': _selectedEvent.name,
            'isDone': false
          }));

      final String serverToken =
          'AAAAZi0VGf8:APA91bEqLIOYgFdCFzFOFPC6FdTEBaNVZyV3een6hwuG_8DS1Aozajs_tSDOPhAIqR8yu1psvPRACadWdigBpSS1csVFi9b21r3tAxGMqWoo1rxqtYVhJlMFM9zxZ2ixAsYmmmKCydTz';

      final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

      await firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
      final fcmTocken = await firebaseMessaging.getToken();
      print(fcmTocken);
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body':
                  '${_selectedItem.name} By ${adminNameTextEditingController.text}',
              'title': 'Vadi Book'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': '/topics/all' // await firebaseMessaging.getToken(),
          },
        ),
      );
      final Completer<Map<String, dynamic>> completer =
          Completer<Map<String, dynamic>>();

      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          completer.complete(message);
        },
      );
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.subscribeToTopic('all');
    } catch (e) {
      print(e);
    }
    addressTextEditingController.clear();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    print("AMit");
    setState(() {
      _isLoad = false;
    });
  }
}
