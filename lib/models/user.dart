class User {
  String id;
  String firstName;
  String lastName;

  String userName;

  String? avatar;

  User({
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.avatar,
    required this.id,
  });
}
