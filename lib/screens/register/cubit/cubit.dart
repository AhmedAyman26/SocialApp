import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_user_model.dart';
import 'package:socialapp/screens/login/cubit/states.dart';
import 'package:socialapp/screens/social_layout/layout.dart';
import 'package:socialapp/screens/register/cubit/states.dart';
import 'package:socialapp/shared/constants/constants.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates>{
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context)=>BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? uId,
    context
  })
  {
    emit(SocialRegisterLoadingState());

      FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,

    ).then((value)
    {
      userCreate(
          email: email,
          name: name,
          phone: phone,
          uId: value.user!.uid,
      );
      emit(SocialRegisterSuccesState());
    }).catchError((e)
      {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Password is to weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email"))
            ..show();
        }});

  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
})
  {
    SocialUserModel model=SocialUserModel(
      username: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio...',
      cover: 'https://img.freepik.com/free-photo/photo-delighted-cheerful-afro-american-woman-with-crisp-hair-points-away-shows-blank-space-happy-advertise-item-sale-wears-orange-jumper-demonstrates-where-clothes-shop-situated_273609-26392.jpg?w=740&t=st=1666308935~exp=1666309535~hmac=14112bdae0f798397c8d2c56e30407fa4fe403e9580099acf12bc93c7754d807',
      image: 'https://img.freepik.com/premium-photo/young-caucasian-man-isolated-blue-background-pointing-front-with-fingers_1187-239271.jpg?w=740'

    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then((value)
    {
      emit(SocialCreateUserSuccessState());
    }).catchError((error)
    {
      emit(SocialCreateUserErrorState(error.toString()));
    });
      // 'email': email,
      // 'username': name,
      // 'uId': value.user!.uid,
      // 'phone':phone,

  }
  IconData suffix = Icons.remove_red_eye;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.remove_red_eye : Icons.visibility_off;
    emit(SocialRegisterChangePasswordVisibilityState());
  }

}