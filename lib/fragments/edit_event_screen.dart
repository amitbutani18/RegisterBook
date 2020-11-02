import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/event_list_screen.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:registerBook/widget/custom_snackbar.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  EditEvent({this.event});
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  TextEditingController nameTextEditingController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoad = false;

  validateField(BuildContext context) {
    if (nameTextEditingController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter event name', SnackBartype.nagetive);
      return false;
    }
    return true;
  }

  _submit() async {
    setState(() {
      _isLoad = true;
    });
    await Provider.of<FirebaseMethods>(context, listen: false).updateEvent(
        widget.event.id,
        nameTextEditingController.text,
        widget.event.createdBy);
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EventListScreen()));
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    nameTextEditingController = TextEditingController(text: widget.event.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Event'),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                TextField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(labelText: 'Event name'),
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
