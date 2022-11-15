import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/screens/social_layout/cubit/cubit.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';

class NewPostScreen extends StatelessWidget {
  var textController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Create post'
            ),
            actions:
            [
              TextButton(
                onPressed: ()
                {
                  var now=DateTime.now();
                  if(SocialCubit.get(context).postImageFile ==null)
                  {
                    SocialCubit.get(context).createPost(
                        dateTime: now.toString(),
                        text: textController.text,
                    );
                  }else
                  {
                    SocialCubit.get(context).uploadPostImage(dateTime: now.toString(), text: textController.text);
                  }
                },
                child: Text(
                    'POST'
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: (
                Column(
                  children:
                  [
                    if(state is SocialCreatePostLoadingState)
                      LinearProgressIndicator(),
                    if(state is SocialCreatePostLoadingState)
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                      children:
                      [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            '${SocialCubit.get(context).userModel!.username}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                            hintText: 'what on your mind ...',
                            border: InputBorder.none
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if(SocialCubit.get(context).postImageFile!=null)
                      Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                image: FileImage(SocialCubit.get(context).postImageFile!)as ImageProvider,
                                fit: BoxFit.cover),
                          ),
                        ),
                        IconButton(
                          onPressed: ()
                          {
                            SocialCubit.get(context).removePostImage();
                          },
                          icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(
                              Icons.close,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: ()
                            {
                              SocialCubit.get(context).getpostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'add photo'
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: (){},
                            child: Text(
                                '# tags'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );
  }
}
