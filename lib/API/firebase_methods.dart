import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Vadi {
  String id;
  String name;
  DateTime createdAt;
  String createdBy;

  Vadi({this.id, this.name, this.createdAt, this.createdBy});
}

class Event {
  String id;
  String name;
  DateTime createdAt;
  String createdBy;

  Event({this.id, this.name, this.createdAt, this.createdBy});
}

class VadiForCalendar {
  String id;
  String name;
  String vadiName;
  String billNumber;
  String address;
  String adminName;
  DateTime eventDate;
  String eventTime;
  String eventDetails;
  String notes;
  String mobileNumber;
  DateTime bookingDate;
  String eventName;
  bool isDone;

  VadiForCalendar(
      {this.id,
      this.name,
      this.vadiName,
      this.eventName,
      this.billNumber,
      this.adminName,
      this.address,
      this.eventDate,
      this.eventDetails,
      this.eventTime,
      this.notes,
      this.mobileNumber,
      this.bookingDate,
      this.isDone});
}

class FirebaseMethods with ChangeNotifier {
  List<Vadi> _vadiList = [];

  List<Vadi> get vadiList {
    return [..._vadiList];
  }

  List<Event> _eventList = [];

  List<Event> get eventList {
    return [..._eventList];
  }

  List<VadiForCalendar> _vadiForCalendar = [];

  List<VadiForCalendar> get vadiForCalendar {
    return [..._vadiForCalendar];
  }

  Map<DateTime, List<VadiForCalendar>> _mapList = {};

  Map<DateTime, List<VadiForCalendar>> get mapList {
    return {..._mapList};
  }

  removeVadi(int index) {
    _vadiList.removeAt(index);
    notifyListeners();
  }

  Future<void> getAndSetVadi() async {
    const url = 'https://registerbook-a5d27.firebaseio.com/vadiList.json';
    final response = await http.get(url);
    // print(response.body);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
//        print('no data');
      return;
    }
    final List<Vadi> loadedProducts = [];

    extractData.forEach((vadiId, vadiData) {
      // print(key);
      loadedProducts.add(Vadi(
        id: vadiId,
        name: vadiData['Name'],
        createdAt: DateTime.parse(vadiData['dateTime']),
        createdBy: vadiData['createdBy'],
      ));
    });
    _vadiList = loadedProducts;
    notifyListeners();
  }

  Future<void> getAndSetEvent() async {
    const url = 'https://registerbook-a5d27.firebaseio.com/eventList.json';
    final response = await http.get(url);
    print(response.body);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
//        print('no data');
      return;
    }
    final List<Event> loadedProducts = [];
    print(extractData);
    extractData.forEach((eventId, eventData) {
      // print(key);
      loadedProducts.add(Event(
        id: eventId,
        name: eventData['eventName'],
        createdAt: DateTime.parse(eventData['dateTime']),
        createdBy: eventData['createdBy'],
      ));
    });
    _eventList = loadedProducts;
    notifyListeners();
  }

  Future<void> updateEvent(
    String eventId,
    String newName,
    String createdBy,
  ) async {
    final url =
        'https://registerbook-a5d27.firebaseio.com/eventList/$eventId.json';
//     final response = await http.get(url);
//     print(response.body);
//     final extractData = json.decode(response.body) as Map<String, dynamic>;
//     if (extractData == null) {
// //        print('no data');
//       return;
//     }
//     final List<Event> loadedProducts = [];
//     print(extractData);
    await http.put(url,
        body: json.encode({
          'eventName': newName,
          'createdBy': createdBy,
          'dateTime': DateTime.now().toIso8601String(),
        }));
    // _eventList = loadedProducts;
    notifyListeners();
  }

  Future<void> getAndSetVadiInCalendar(String vadiId) async {
    final url =
        'https://registerbook-a5d27.firebaseio.com/Register/$vadiId.json';
    final response = await http.get(url);
    // print(response.body);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    Map<DateTime, List<VadiForCalendar>> map = {};
    final List<VadiForCalendar> loadedProducts = [];
    extractData.forEach((vadiIdd, vadiData) {
      loadedProducts.add(VadiForCalendar(
        id: vadiIdd,
        name: vadiData['name'],
        adminName: vadiData['adminName'],
        address: vadiData['address'],
        billNumber:
            vadiData['billNumber'] == null ? '' : vadiData['billNumber'],
        bookingDate: DateTime.parse(vadiData['bookingDate']),
        eventDate: DateTime.parse(vadiData['eventDate']),
        eventTime: vadiData['evenTime'],
        eventDetails: vadiData['eventDetails'],
        mobileNumber: vadiData['mobileNumber'],
        notes: vadiData['notes'],
        vadiName: vadiData['vadiName'],
        eventName: vadiData['eventName'],
        isDone: vadiData['isDone'],
      ));
    });

    extractData.forEach((key, vadiData) {
      List<VadiForCalendar> newList = [];
      map.putIfAbsent(DateTime.parse(vadiData['eventDate']), () {
        final date = DateTime.parse(vadiData['eventDate']);
        print(loadedProducts.length);
        for (var i = 0; i < loadedProducts.length; i++) {
          if (date == loadedProducts[i].eventDate) {
            newList.add(loadedProducts[i]);
          }
        }
        return newList;
      });
      map.forEach((key, value) {
        for (var i = 0; i < value.length; i++) {
          print(value[i].address);
        }
      });
      print(map);
    });

    _vadiForCalendar = loadedProducts;
    _mapList = map;
    notifyListeners();
  }
}
