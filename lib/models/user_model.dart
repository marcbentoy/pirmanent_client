class User {
  final String name;
  final String email;
  final String publicKey;
  final int? fingerprintId;

  User({
    required this.name,
    required this.email,
    required this.publicKey,
    this.fingerprintId,
  });
}
