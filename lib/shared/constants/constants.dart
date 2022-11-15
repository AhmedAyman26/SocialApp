import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/screens/login/social_login_screen.dart';
import 'package:socialapp/shared/local/cache_helper.dart';

String? uId;
void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (Route<dynamic> route) => false,
    );

void signOut(context) {
  CacheHelper.removeData(
    key: 'uId',
  ).then((value)
  {
    if(value)
    {
      navigateAndFinish(context, SocialLoginScreen());
    }
  });
}

