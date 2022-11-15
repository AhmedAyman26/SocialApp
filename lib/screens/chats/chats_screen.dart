import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_user_model.dart';
import 'package:socialapp/screens/chat_details/chat_details_screen.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';
import 'package:socialapp/shared/constants/constants.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
      }, builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length>0,
          builder: (context)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=>buildChatItem(SocialCubit.get(context).users[index],context),
            separatorBuilder: (context,index)=>Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context)=>Center(
            child: CircularProgressIndicator(),
          ),
        );
        },
    );
  }
  Widget buildChatItem(SocialUserModel model,context)=>InkWell(
    onTap: ()
    {
      navigateTo(context, ChatDetailsScreen(userModel: model));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              '${model.image}'
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Row(
                  children: [
                    Text(
                      '${model.username}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
