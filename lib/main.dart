import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/bloc_observer.dart';
import 'package:socialapp/screens/login/social_login_screen.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/layout.dart';
import 'package:socialapp/shared/constants/constants.dart';
import 'package:socialapp/shared/local/cache_helper.dart';
import 'package:socialapp/shared/styles/themes.dart';

bool isLogin=false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CacheHelper.init();
  var user=FirebaseAuth.instance.currentUser;

  uId= CacheHelper.getData(key: 'uId');
  if(uId==null)
  {
    isLogin=false;
  }else
  {
    isLogin=true;
  }
  print(isLogin.toString());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData()..getPosts()..getUsers(),
      child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isLogin==false? SocialLoginScreen() : const SocialLayout(),
      theme: lightTheme,

    )
    );
  }
}