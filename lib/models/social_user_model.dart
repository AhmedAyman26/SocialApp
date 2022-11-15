class SocialUserModel
{
  String? username;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;

  SocialUserModel({
   this.username,
   this.email,
   this.phone,
   this.uId,
   this.image,
   this.cover,
   this.bio
});
  SocialUserModel.fromJson(Map<String,dynamic>? json)
  {
    username=json!['username'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
  }
  Map<String , dynamic> toMap()
  {
    return
      {
        'username':username,
        'email':email,
        'phone':phone,
        'uId':uId,
        'image':image,
        'cover':cover,
        'bio':bio,
      };
  }
}