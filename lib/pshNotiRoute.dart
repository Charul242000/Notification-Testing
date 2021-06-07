import 'package:flutter/material.dart';
class PushNotificationRoute extends ModalRoute {
  final Widget child;

  PushNotificationRoute({required this.child});

  //Override other methods to your requirement

  //This is important
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Builder(builder: (BuildContext context) {
        return child;
      }),
    );
  }


  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => throw UnimplementedError();

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => throw UnimplementedError();

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => throw UnimplementedError();

  @override
  // TODO: implement maintainState
  bool get maintainState => throw UnimplementedError();

  @override
  // TODO: implement opaque
  bool get opaque => throw UnimplementedError();
}