import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Notification.dart';


List<dynamic> notificationData = [];
const AndroidNotificationChannel channel=AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high,
  playSound: true
);
//to handle background messaging
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print('//////////////////////////////////////////');
  print('A bg message ust showed up: ${message.messageId}');
  print('//////////////////////////////////////////');
}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    FirebaseMessaging.onMessage.listen((RemoteMessage message)async{
      RemoteNotification? notification=message.notification;
      AndroidNotification? android=message.notification?.android;
      if(notification!=null&& android!=null){
        print('###########################################');
        print('App Running');
        print(notification);

        await saveNotifications(notification.title, notification.body, 0);
        await getNotifications();
        print('##########################################');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon:'@mipmap/ic_launcher',
              )
            )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      RemoteNotification? notification=message.notification;
      AndroidNotification? android=message.notification?.android;
      if(notification!=null&& android!=null){
        print('****************************');
        print('onMessageOpenedApp');
        print(notification);
        print('****************************');
      showDialog(context: context,builder: (_){
        return AlertDialog(
          title: Text(notification.title.toString()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body.toString()),
              ],
            ),
          ),
        );
      });
      }
    });

  }

  void showNotification() {
    setState(() {

      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
       0,
        "Testing $_counter",
      "How you doing?",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon:'@mipmap/ic_launcher'
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Notificationsss()));
            }, child: Text('Nextscreen'))

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
Future<void> saveNotifications (title, body, [read = 0])async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
  //notification.title,
  //notification.body,

  var data = { "name":  title, "body": body, "status": read  };
  notificationData.add(data);

  print('///////////////////////////////////');
  print('Saving notificiations to an Array');
  print(notificationData);
  prefs.setString('notifications', jsonEncode(notificationData));

  print(prefs.getString('notifications'));
  print('///////////////////////////////////');
}

Future<String> getNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringValue = prefs.getString('notifications')!;
  // var stringValue = "Heck";
  print('########################################');
  print(stringValue);
  print('########################################');
  return "0";
}