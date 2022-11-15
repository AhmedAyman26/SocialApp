import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/models/comment_model.dart';
import 'package:socialapp/models/message_model.dart';
import 'package:socialapp/models/post_model.dart';
import 'package:socialapp/models/social_user_model.dart';
import 'package:socialapp/screens/chats/chats_screen.dart';
import 'package:socialapp/screens/feeds/feeds_screen.dart';
import 'package:socialapp/screens/new_post/new_post_screen.dart';
import 'package:socialapp/screens/settings/settings_screen.dart';
import 'package:socialapp/screens/social_layout/cubit/states.dart';
import 'package:socialapp/screens/users/users_screen.dart';
import 'package:socialapp/shared/constants/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);


  SocialUserModel? userModel;

  void getUserData() async {
    emit(SocialGetUserLoadingStates());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print(value.id);
      print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorStates());
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = ['Home', 'Chats', 'Posts', 'Users', 'Settings'];
  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }


  File? profileImageFile;
  var picker=ImagePicker();
  Future getProfileImage()async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile !=null){
      profileImageFile=File(pickedFile.path);
      print(pickedFile.path.toString());
      emit(SocialProfileImagePickedSuccessState());
    }else
    {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorState());
    }

  }

  File? coverImageFile;
  Future getCoverImage()async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile !=null){
      coverImageFile=File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }else
    {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorState());}
  }

  //uploadImageFireBase

  void uploadProfileImage({
    required String username,
    required String phone,
    required String bio,
  }){
    emit(SocialUpdateUserLoadingState());
    FirebaseStorage.instance.ref()
        .child('users/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!).then((value)  {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(username: username, phone: phone, bio: bio,
          image: value,);
        // emit(SocialUploadProfileImageSuccessState());

      }).catchError((error){
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({required String username,
    required String phone,
    required String bio,}){
    emit(SocialUpdateUserLoadingState());
    FirebaseStorage.instance.ref()
        .child('users/${Uri.file(coverImageFile!.path).pathSegments.last}')
        .putFile(coverImageFile!).then((value)  {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(username: username, phone: phone, bio: bio,cover: value);

      }).catchError((error){
        // emit(SocialUploadCoverImageSuccessState());
      });
    }).catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String username,
    required String phone,
    required String bio,
    String? image,
    String? cover,

  }){
    // emit(SocialUpdateLoadingState());
    SocialUserModel modelMap=SocialUserModel(
        username: username,
        phone: phone,
        bio: bio,
        cover:cover?? userModel!.cover,
        image: image?? userModel!.image,
        email:   userModel!.email,
        uId:    userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(modelMap.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error){
    });
  }

  File? postImageFile;
  Future getpostImage()async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile !=null){
      postImageFile=File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }else
    {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());}
  }

  void uploadPostImage({
    required String dateTime,
    required String text,

  })
  {
    emit(SocialCreatePostLoadingState());
    FirebaseStorage.instance.ref()
        .child('posts/${Uri.file(postImageFile!.path).pathSegments.last}')
        .putFile(postImageFile!).then((value)  {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value
        );
        print(value);

      });
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage()
  {
    postImageFile=null;
    emit(SocialRemovePostImageState());
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,

  }){
    emit(SocialCreatePostLoadingState());
    // emit(SocialUpdateLoadingState());
    PostModel model=PostModel(
      username: userModel!.username,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??''
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());

    })
        .catchError((error){
          emit(SocialCreatePostErrorState());
    });
  }
  List<PostModel> posts=[];
  List<String>postsId=[];
  List<int> likes=[];
  void getPosts()
  {
    emit(SocialGetPostLoadingStates());
    FirebaseFirestore.instance.collection('posts').get().then((value)
    {
      value.docs.forEach((element)
      {
        element.reference.collection('likes').get()
            .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          print(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostSuccessStates());

        }).catchError((){});
      });
    }).catchError((error)
    {
      emit(SocialGetPostErrorStates());
    });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(userModel!.uId).set(
        {
          'like':true,
        }).then((value)
    {
      emit(SocialLikePostSuccessState());
    }).catchError(()
    {
      emit(SocialLikePostErrorState());
    });
  }

  void createComment({required String postId,required String comment,required String dataTime}){
    emit(SocialCreateCommentLoadingState());
    // commentList.add(comment);
    // print(_commentModel!.text??'null');
    CommentModel commentModel=CommentModel(
      username: userModel!.username,
      image:userModel!.image,
      uId: userModel!.uId,
      text:comment,
      dateTime:dataTime ,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Comments')
        .doc(userModel!.uId)
        .collection('user Comment')
        .add(commentModel.toMap()
    ).then((value) {
      emit(SocialCreateCommentSuccessState());
      getComments(postId);
    })
        .catchError((error){
      emit(SocialCreateCommentErrorState());

    });

  }
  List<String> commentList=[];
  List<CommentModel> commentModelList=[];
  String? newPostId;

  void getComments(String postId){
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Comments')
        .doc(userModel!.uId)
        .collection('user Comment')
        .orderBy('dateTime')
        .get()
        .then((value) {
      commentModelList.clear();
      commentList.clear();
      value.docs.forEach((element) {
        // commentModel=   CommentModel.fromJson(element.data());
        commentModelList.add(CommentModel.fromJson(element.data()));
        commentList.add(element.id);
        emit(SocialGetCommentsSuccessState(postId));
      });
      print(postId+' 3');
      newPostId=postId ;
      print(newPostId);
      emit(SocialGetCommentsSuccessState(postId));
    }).catchError((error){
      emit(SocialGetCommentsErrorState());
      print(error);
    });
  }
  List<SocialUserModel>users=[];
  void getUsers()
  {
    if(users.length==0) {
      emit(SocialGetAllUsersLoadingStates());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          element.reference.collection('likes').get()
              .then((value) {
            users.add(SocialUserModel.fromJson(element.data()));
            emit(SocialGetAllUsersSuccessStates());
          }).catchError(() {});
        });
      }).catchError((error) {
        emit(SocialGetAllUsersErrorStates());
      });
    }
  }
  void sendMessage({
  required String receiverId,
  required String dateTime,
  required String text,
})
  {
    MessageModel model= MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value){
          emit(SocialSendMessageSuccessState());
    })
        .catchError((){
          emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value){
      emit(SocialSendMessageSuccessState());
    })
        .catchError((){
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages=[];
  void getMessages ({
  required String receiverId,
})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
         .listen((event)
    {
      messages=[];
      event.docs.forEach((element)
      {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
