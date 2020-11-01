import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:registerBook/fragments/HomeScreen.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:registerBook/widget/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class AdminName extends StatefulWidget {
  @override
  _AdminNameState createState() => _AdminNameState();
}

class _AdminNameState extends State<AdminName> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Center(
          child: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 200),
              child: RaisedButton(
                onPressed: () {
                  if (validateField(context)) {
                    _submit();
                  }
                },
                color: primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
      )),
    ));
  }

  validateField(BuildContext context) {
    if (nameController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter your name', SnackBartype.nagetive);
      return false;
    }
    return true;
  }

  _submit() async {
    final User user = await FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final phone = user.phoneNumber;
    print(phone);
    print(uid);

    final url =
        'https://registerbook-a5d27.firebaseio.com/Admin/$uid/profile.json';

    await http.put(url,
        body: json.encode({
          'mobile': phone,
          'adminName': nameController.text,
        }));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('adminNameSet', true);
    sharedPreferences.setString('adminName', nameController.text);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }
}
