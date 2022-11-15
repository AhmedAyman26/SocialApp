class PostModel
{
  String? username;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;

  PostModel({
    this.username,
    this.uId,
    this.image,
    this.text,
    this.dateTime,
    this.postImage
  });
  PostModel.fromJson(Map<String,dynamic>? json)
  {
    username=json!['username'];
    uId=json['uId'];
    image=json['image'];
    text=json['text'];
    dateTime=json['dateTime'];
    postImage=json['postImage'];
  }
  Map<String , dynamic> toMap()
  {
    return
      {
        'username':username,
        'uId':uId,
        'image':image,
        'text':text,
        'dateTime':dateTime,
        'postImage' :postImage
      };
  }
}