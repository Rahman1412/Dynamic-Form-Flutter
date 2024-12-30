class User{
  String name;
  String email;

  User({required this.name,required this.email});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      name : json["name"],
      email : json["email"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : name,
      "email" : email
    };
  }
}