import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/screens/login/social_login_screen.dart';
import 'package:socialapp/screens/register/cubit/cubit.dart';
import 'package:socialapp/screens/register/cubit/states.dart';
import 'package:socialapp/screens/social_layout/layout.dart';
import 'package:socialapp/shared/constants/constants.dart';
import 'package:socialapp/shared/widgets/widgets.dart';


class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state)
        {
          if(state is SocialCreateUserSuccessState)
          {
            navigateAndFinish(context, SocialLoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = SocialRegisterCubit.get(context);
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REGISTER',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Register to communicate with friends',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              defaultFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'you must enter name';
                                  }
                                },
                                label: 'User Name',
                                prefix: Icons.person,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'you must enter email';
                                  }
                                },
                                label: 'Email',
                                prefix: Icons.email,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                controller: passwordController,
                                label: 'password',
                                prefix: Icons.lock,
                                type: TextInputType.visiblePassword,
                                isPassword: cubit.isPassword,
                                suffix: cubit.suffix,
                                suffixPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'password is too short';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                controller: phoneController,
                                type: TextInputType.phone,
                                validate: (String? value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'you must enter your phone';
                                  }
                                },
                                label: 'phone',
                                prefix: Icons.phone,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                                    defaultButton(
                                    function: ()async
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        cubit.userRegister(
                                            email: emailController.text,
                                            name: nameController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                          context: context
                                        ) ;
                                      }
                                    },
                                    text: 'REGISTER',
                                  ),
                              const SizedBox(
                                height: 15,
                              ),
                            ]),
                      ),
                    ),
                  )));
        },
      ),
    );
  }
}
