import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(
      isAppTitle ? 'SocialGram' : titleText,
      style: TextStyle(
          fontSize: isAppTitle ? 40.0 : 22.0,
          color: Colors.white,
          fontFamily: isAppTitle ? 'KaushanScript' : '',
          fontWeight: FontWeight.w500),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
