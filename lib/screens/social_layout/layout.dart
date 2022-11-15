import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/screens/new_post/new_post_screen.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';
import 'package:socialapp/shared/constants/constants.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState)
        {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
                cubit.titles[cubit.currentIndex]
            ),
            actions: 
            [
              IconButton(
                onPressed:(){},
                icon: const Icon(
                    Icons.notifications_outlined),
              ),
              IconButton(
                onPressed:(){},
                icon: const Icon(
                    Icons.search),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNavBar(index);
            },
            items:
            const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined
                  ),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_outlined
                  ),
                label: 'Chats'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                      Icons.upload_file_outlined
                  ),
                  label: 'Post'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.location_on_outlined
                  ),
                label: 'Users'
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined
                  ),
                label: 'Settings'
              ),

            ],
          ),
        );
      },
    );
  }
}
