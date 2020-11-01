import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/CalendarScreen.dart';
import 'package:registerBook/fragments/booking_details.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:http/http.dart' as http;

class EditBookedVadi extends StatefulWidget {
  VadiForCalendar vadiForCalendar;
  String vadiId;
  EditBookedVadi({this.vadiForCalendar, this.vadiId});

  @override
  _EditBookedVadiState createState() => _EditBookedVadiState();
}

class _EditBookedVadiState extends State<EditBookedVadi> {
  TextEditingController nameTextEditingController;
  TextEditingController addressTextEditingController;
  TextEditingController mobileNumberTextEditingController;
  TextEditingController billNumberTextEditingController;
  TextEditingController eventDetailsTextEditingController;
  TextEditingController notesTextEditingController;
  // TextEditingController bookingDateTextEditingController =
  //     TextEditingController(
  //         text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  TextEditingController eventDateTextEditingController;
  bool _isLoad = false, _isInit = true;
  DateTime selectedDate = DateTime.now();
  TimeOfDay time;
  String _eventDate;
  List<Event> _eventDropdownItems = [];
  Event _selectedEvent;
  List<DropdownMenuItem<Event>> _eventDropdownMenuItems;

  @override
  void initState() {
    super.initState();
    setState(() {
      _eventDropdownItems =
          Provider.of<FirebaseMethods>(context, listen: false).eventList;
    });
    _eventDropdownMenuItems = buildEventDropDownMenuItems(_eventDropdownItems);
    print(_eventDropdownMenuItems.length);
    if (_eventDropdownMenuItems.length != 0) {
      for (var i = 0; i < _eventDropdownMenuItems.length; i++) {
        print(_eventDropdownMenuItems[i].value.name);
        if (_eventDropdownMenuItems[i].value.name ==
            widget.vadiForCalendar.eventName) {
          print(widget.vadiForCalendar.name);
          setState(() {
            _selectedEvent = _eventDropdownMenuItems[i].value;
          });
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      billNumberTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.billNumber);
      nameTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.name);
      addressTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.address);
      eventDetailsTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.eventDetails);
      notesTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.notes);
      mobileNumberTextEditingController =
          TextEditingController(text: widget.vadiForCalendar.mobileNumber);
      eventDateTextEditingController = TextEditingController(
          text: DateFormat("dd/MM/yyyy")
              .format(widget.vadiForCalendar.eventDate));
    }
    _isInit = false;
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

  _submit() async {
    setState(() {
      _isLoad = true;
    });
    // DateTime eventDate =
    //     DateTime.parse(eventDateTextEditingController.text.split('/').first);
    // print(eventDate.toIso8601String());
    try {
      await http.put(
          'https://registerbook-a5d27.firebaseio.com/Register/${widget.vadiId}/${widget.vadiForCalendar.id}.json',
          body: json.encode({
            'billNumber': billNumberTextEditingController.text,
            'name': nameTextEditingController.text,
            'vadiName': widget.vadiForCalendar.vadiName,
            'adminName': widget.vadiForCalendar.adminName,
            'mobileNumber': mobileNumberTextEditingController.text,
            'eventDate': _eventDate == null
                ? widget.vadiForCalendar.eventDate.toIso8601String()
                : _eventDate,
            'evenTime': time == null
                ? widget.vadiForCalendar.eventTime
                : time.format(context),
            'address': addressTextEditingController.text,
            'bookingDate': widget.vadiForCalendar.bookingDate.toIso8601String(),
            'eventDetails': eventDetailsTextEditingController.text,
            'notes': notesTextEditingController.text,
            'eventName': _selectedEvent.name,
            'isDone': widget.vadiForCalendar.isDone,
          }));
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => BookingDetails(
              vadiForCalendar: VadiForCalendar(
                billNumber: billNumberTextEditingController.text,
                id: widget.vadiForCalendar.id,
                name: nameTextEditingController.text,
                adminName: widget.vadiForCalendar.adminName,
                address: addressTextEditingController.text,
                bookingDate: widget.vadiForCalendar.bookingDate,
                eventDate: _eventDate == null
                    ? widget.vadiForCalendar.eventDate
                    : _eventDate,
                eventTime: time == null
                    ? widget.vadiForCalendar.eventTime
                    : time.format(context),
                eventDetails: widget.vadiForCalendar.eventDetails,
                mobileNumber: widget.vadiForCalendar.mobileNumber,
                notes: widget.vadiForCalendar.notes,
                vadiName: widget.vadiForCalendar.vadiName,
                eventName: _selectedEvent.name,
                isDone: widget.vadiForCalendar.isDone,
              ),
              vadiId: widget.vadiId,
            )));
    print("AMit");
    setState(() {
      _isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Details'),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: billNumberTextEditingController,
                    decoration: InputDecoration(labelText: 'Bill number'),
                  ),
                  TextField(
                    controller: nameTextEditingController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: addressTextEditingController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    controller: mobileNumberTextEditingController,
                    decoration: InputDecoration(labelText: 'Mobile Number'),
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
                  TextField(
                    maxLines: null,
                    controller: eventDetailsTextEditingController,
                    decoration: InputDecoration(labelText: 'Event Details'),
                  ),
                  TextField(
                    maxLines: null,
                    controller: notesTextEditingController,
                    decoration: InputDecoration(labelText: 'Notes'),
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
                              // if (validateField(context)) {
                              _submit();
                              // }
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
}
