class CommentModel{
  late String ?username;
  late String? uId;
  late String ?image;
  late String ?dateTime;
  late String ?text;

  CommentModel({
    this.username,
    this.dateTime,
    this.text,
    this.uId,
    this.image,
  });

  CommentModel.fromJson(Map<String,dynamic>json){
    username=json['username'];
    dateTime=json['dateTime'];
    text=json['text'];
    uId=json['uId'];
    image=json['image'];
  }

  Map<String,dynamic>toMap() {
    return{
      'username':username,
      'dateTime':dateTime,
      'text':text,
      'uId':uId,
      'image':image,
    };

  }
}