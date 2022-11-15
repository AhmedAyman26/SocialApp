abstract class SocialStates{}

class SocialInitialStates extends SocialStates{}

class SocialLoadingStates extends SocialStates{}

class SocialGetUserLoadingStates extends SocialStates{}

class SocialGetUserSuccessStates extends SocialStates{}

class SocialGetUserErrorStates extends SocialStates{}

class SocialGetAllUsersLoadingStates extends SocialStates{}

class SocialGetAllUsersSuccessStates extends SocialStates{}

class SocialGetAllUsersErrorStates extends SocialStates{}

class SocialGetPostLoadingStates extends SocialStates{}

class SocialGetPostSuccessStates extends SocialStates{}

class SocialGetPostErrorStates extends SocialStates{}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}

class SocialProfileImagePickedSuccessState extends SocialStates{}

class SocialProfileImagePickedErrorState extends SocialStates{}

class SocialCoverImagePickedSuccessState extends SocialStates{}

class SocialCoverImagePickedErrorState extends SocialStates{}

class SocialUploadProfileImageSuccessState extends SocialStates{}

class SocialUploadProfileImageErrorState extends SocialStates{}

class SocialUploadCoverImageSuccessState extends SocialStates{}

class SocialUploadCoverImageErrorState extends SocialStates{}

class SocialUpdateUserLoadingState extends SocialStates{}

class SocialUpdateUserErrorState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

class SocialPostImagePickedSuccessState extends SocialStates{}

class SocialPostImagePickedErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}

class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates{}

class SocialCreateCommentLoadingState extends SocialStates{}

class SocialCreateCommentSuccessState extends SocialStates{}

class SocialCreateCommentErrorState extends SocialStates{}

class SocialGetCommentsLoadingState extends SocialStates{}

class SocialGetCommentsSuccessState extends SocialStates
{
  late String insidePostId;
  SocialGetCommentsSuccessState(this.insidePostId);
}

class SocialGetCommentsErrorState extends SocialStates{}

// chats
class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{}
class SocialGetMessageSuccessState extends SocialStates{}
class SocialGetMessageErrorState extends SocialStates{}