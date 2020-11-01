import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:http/http.dart' as http;
import 'package:registerBook/fragments/CalendarScreen.dart';
import 'package:registerBook/fragments/edit_booked_vadi.dart';
import 'package:registerBook/integrations/colors.dart';

class BookingDetails extends StatefulWidget {
  VadiForCalendar vadiForCalendar;
  String vadiId;
  BookingDetails({this.vadiForCalendar, this.vadiId});

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool _isBook = false;

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Colors.black),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isBook = widget.vadiForCalendar.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => CalendarScreen(
                  vadiId: widget.vadiId,
                )));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          backgroundColor: primaryColor,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => EditBookedVadi(
                          vadiForCalendar: widget.vadiForCalendar,
                          vadiId: widget.vadiId,
                        )))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _appbar(),

                  SizedBox(
                    height: 30,
                  ),
                  CustomTitle(title: "Bill Number"),
                  CustomSubString(subString: widget.vadiForCalendar.billNumber),
                  CustomDivider(),
                  CustomTitle(title: "Vadi Name"),
                  CustomSubString(subString: widget.vadiForCalendar.vadiName),
                  CustomDivider(),
                  CustomTitle(title: "Admin Name"),
                  CustomSubString(subString: widget.vadiForCalendar.adminName),
                  CustomDivider(),
                  CustomTitle(title: "Name"),
                  CustomSubString(subString: widget.vadiForCalendar.name),
                  CustomDivider(),
                  CustomTitle(title: "Mobile Number"),
                  CustomSubString(
                      subString: widget.vadiForCalendar.mobileNumber),
                  CustomDivider(),
                  CustomTitle(title: "Address"),
                  CustomSubString(subString: widget.vadiForCalendar.address),
                  CustomDivider(),
                  CustomTitle(title: "Event Date"),
                  CustomSubString(
                      subString: DateFormat("dd/MM/yyyy")
                          .format(widget.vadiForCalendar.eventDate)),
                  CustomDivider(),
                  CustomTitle(title: "Event Time"),
                  CustomSubString(subString: widget.vadiForCalendar.eventTime),
                  CustomDivider(),
                  CustomTitle(title: "Event Name"),
                  CustomSubString(subString: widget.vadiForCalendar.eventName),
                  CustomDivider(),
                  CustomTitle(title: "Event Details"),
                  CustomSubString(
                      subString: widget.vadiForCalendar.eventDetails),
                  CustomDivider(),
                  CustomTitle(title: "Notes"),
                  CustomSubString(subString: widget.vadiForCalendar.notes),
                  CustomDivider(),
                  CustomTitle(title: "Booking Date"),
                  CustomSubString(
                      subString: DateFormat("dd/MM/yyyy")
                          .format(widget.vadiForCalendar.bookingDate)),

                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _isBook = !_isBook;
                          });
                          try {
                            await http.put(
                                'https://registerbook-a5d27.firebaseio.com/Register/${widget.vadiId}/${widget.vadiForCalendar.id}.json',
                                body: json.encode({
                                  'name': widget.vadiForCalendar.name,
                                  'vadiName': widget.vadiForCalendar.vadiName,
                                  'adminName': widget.vadiForCalendar.adminName,
                                  'mobileNumber':
                                      widget.vadiForCalendar.mobileNumber,
                                  'eventDate': widget.vadiForCalendar.eventDate
                                      .toIso8601String(),
                                  'evenTime': widget.vadiForCalendar.eventTime,
                                  'address': widget.vadiForCalendar.address,
                                  'bookingDate': widget
                                      .vadiForCalendar.bookingDate
                                      .toIso8601String(),
                                  'eventDetails':
                                      widget.vadiForCalendar.eventDetails,
                                  'notes': widget.vadiForCalendar.notes,
                                  'isDone': _isBook
                                }));
                          } catch (e) {
                            print(e);
                          }
                          print(widget.vadiForCalendar.id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        color: _isBook
                            ? Color.fromRGBO(202, 3, 3, 1)
                            : Colors.greenAccent,
                        child: Text(
                          _isBook ? "CANCLE" : "BOOK",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isBook ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   height: 400,
                  //   child: GridView.count(
                  //     // scrollDirection: Axis.horizontal,
                  //     crossAxisCount: 2,
                  //     children: List.generate(
                  //       4,
                  //       (index) {
                  //         return Container(
                  //           child: Card(
                  //             // color: Colors.amber,
                  //             child: Center(
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.date_range,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text("${text[index]}"),
                  //                   Text("DETAILS")
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 30,
    );
  }
}

class CustomSubString extends StatelessWidget {
  const CustomSubString({
    Key key,
    @required this.subString,
  }) : super(key: key);

  final String subString;

  @override
  Widget build(BuildContext context) {
    return Text(
      subString,
      style: TextStyle(
        fontSize: 15,
        // fontFamily: fontBold,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String title;

  const CustomTitle({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          // fontFamily: fontBold,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
