class User {
  int id;
  String name;
  String username;
  String email;

  User({this.id, this.name, this.username, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
  }
}
