

import 'package:flutter/material.dart';

class NotificationsServices {

  static  GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbarError( String messege ) {

    final snackBar = new SnackBar(
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Text(messege, style: TextStyle(color: Colors.white, fontSize: 20),),
    );

    messengerKey.currentState!.showSnackBar(snackBar);

  }

}