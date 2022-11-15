import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';
import 'package:socialapp/shared/widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController=TextEditingController();
  var bioController=TextEditingController();
  var phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var userModel=SocialCubit.get(context).userModel;
        var profileImage=SocialCubit.get(context).profileImageFile;
        var coverImage=SocialCubit.get(context).coverImageFile;
        nameController.text=userModel!.username!;
        bioController.text=userModel.bio!;
        phoneController.text=userModel.phone!;
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Edit Profile'
            ),
            titleSpacing: 5,
            actions:
            [
              TextButton(
                onPressed: ()
                {
                  SocialCubit.get(context).updateUser(
                    username: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                child: Text(
                    'Update'
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  if(state is SocialUpdateUserLoadingState)
                  LinearProgressIndicator(),
                  Container(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                      image: coverImage==null?NetworkImage(
                                          '${userModel.cover}'
                                      ) : FileImage(coverImage)as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              IconButton(
                                onPressed: ()
                                {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 63,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage ==null ? NetworkImage(
                                      '${userModel.image}'
                                  ) :FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if(SocialCubit.get(context).profileImageFile!=null || SocialCubit.get(context).coverImageFile!=null)
                    Row(
                    children:
                    [
                      if(SocialCubit.get(context).profileImageFile!=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                              function: ()
                              {
                                SocialCubit.get(context).uploadProfileImage(username: nameController.text, phone: phoneController.text, bio: bioController.text);
                              },
                              text: 'upload profile',
                              ),
                              if(state is SocialUpdateUserLoadingState)
                                SizedBox(height: 5,),
                              if(state is SocialUpdateUserLoadingState)
                                LinearProgressIndicator(),
                            ],
                          ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if(SocialCubit.get(context).coverImageFile!=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                              function: ()
                              {
                                SocialCubit.get(context).uploadCoverImage(username: nameController.text, phone: phoneController.text, bio: bioController.text);
                              },
                              text: 'upload cover',
                              ),
                              if(state is SocialUpdateUserLoadingState)
                                SizedBox(height: 5,),
                              if(state is SocialUpdateUserLoadingState)
                                LinearProgressIndicator(),
                            ],
                          ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'you must enter your name';
                      }
                    },
                    label: 'name',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'you must enter your bio';
                      }
                    },
                    label: 'bio',
                    prefix: Icons.info,
                  ),
                  SizedBox(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
