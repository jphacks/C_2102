class UserModel{
  String uid;
  int color;
  int imageIndex;

  UserModel({required this.color, required this.uid, required this.imageIndex});
}

class UserRoomModel {
  int color;
  int imageIndex;

  UserRoomModel(this.color, this.imageIndex);
}