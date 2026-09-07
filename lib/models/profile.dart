class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String profession;
  final String about;
  final String avatarUrl; // can be empty – we’ll render initials

  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.profession,
    required this.about,
    this.avatarUrl = '',
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      (firstName.isNotEmpty ? firstName[0] : '') +
      (lastName.isNotEmpty ? lastName[0] : '');
}
