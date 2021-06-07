import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Notificationsss extends StatefulWidget {


  @override
  _NotificationsssState createState() => _NotificationsssState();
}

class _NotificationsssState extends State<Notificationsss> {
  var jsonData;







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('No data Found') ,
            SizedBox(height: 8,),
           Text('No data Found'),
          ],
        ),
      ),
    );
  }
}

Future<String> getNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringValue = prefs.getString('notifications')!;
  // var stringValue = "Heck";
  print('########################################');
  print(stringValue);
  print('########################################');
  return stringValue;
}
