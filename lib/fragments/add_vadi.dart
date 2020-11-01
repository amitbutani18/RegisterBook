import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registerBook/fragments/HomeScreen.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:http/http.dart' as http;
import 'package:registerBook/widget/custom_snackbar.dart';

class VadiBookingForm extends StatefulWidget {
  @override
  _VadiBookingFormState createState() => _VadiBookingFormState();
}

class _VadiBookingFormState extends State<VadiBookingForm> {
  TextEditingController nameTextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoad = false;

  validateField(BuildContext context) {
    if (nameTextEditingController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter vadi name', SnackBartype.nagetive);
      return false;
    }
    return true;
  }

  _submit() async {
    setState(() {
      _isLoad = true;
    });
    User firebaseUser = await _auth.currentUser;
    await http.post('https://registerbook-a5d27.firebaseio.com/vadiList.json',
        body: json.encode({
          'Name': nameTextEditingController.text,
          'createdBy': firebaseUser.uid,
          'dateTime': DateTime.now().toIso8601String(),
        }));
    nameTextEditingController.clear();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    print("AMit");
    setState(() {
      _isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Vadi'),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                TextField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(labelText: 'Vadi name'),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                                vertical: 8, horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Submit',
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
    );
  }
}
