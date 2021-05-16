class User {
  String firstName;
  String lastName;
  String email;
  String password;
  int age;
  String gender;
  String city;
  String image;

  User(this.firstName, this.lastName, this.email, this.password, this.age,
      this.gender, this.city, this.image);

  static List<User> userList() => [
        User("First", "Last", "example@name.com", "password", 21, "Male",
            "Toronto", "assets/images/mascot.png"),
        User("First", "Last", "example@name.com", "password", 21, "Male",
            "Toronto", "assets/images/mascot.png"),
        User("First", "Last", "example@name.com", "password", 21, "Male",
            "Toronto", "assets/images/mascot.png"),
        User("First", "Last", "example@name.com", "password", 21, "Male",
            "Toronto", "assets/images/mascot.png"),
      ];
}
