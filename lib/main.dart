import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/HomeScreen.dart';
import 'package:registerBook/fragments/login_page.dart';
import 'package:registerBook/fragments/splash_page.dart';
import 'package:registerBook/stores/login_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var androidChannelSpecifics = AndroidNotificationDetails(
          'CHANNEL_ID',
          'CHANNEL_NAME',
          "CHANNEL_DESCRIPTION",
          importance: Importance.Max,
          priority: Priority.High,
          playSound: true,
          timeoutAfter: 5000,
          styleInformation: DefaultStyleInformation(true, true),
        );
        var iosChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics =
            NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          '${message['notification']['title']}', // Notification Title
          'By ${message['notification']['body']}', // Notification Body, set as null to remove the body
          platformChannelSpecifics,
          payload: 'New Payload', // Notification Payload
        );
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('flutter_devs');
    // var initializationSettingsIOs = IOSInitializationSettings();
    // var initSetttings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOs);

    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);

    // showNotification();
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
        ChangeNotifierProvider.value(value: FirebaseMethods()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
      ),
    );
  }
}
