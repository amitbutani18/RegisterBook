import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlotList {
  static Future<List<Plot>> apiPlotList() async {
    http.Response response = await http
        .post("http://smartclick4you.com/registerBook/v1/partyploatlist");
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        var datalist = map["data"] as List;
        List<Plot> list = datalist.map((e) => Plot.fromJson(e)).toList();
        return list;
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
  }
}

class Plot {
  String id;
  String name;
  String created_at;
  String updated_at;

  Plot({this.id, this.name, this.created_at, this.updated_at});

  factory Plot.fromJson(Map<String, dynamic> json) {
    return Plot(
        id: json['id'],
        name: json['name'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }
}
