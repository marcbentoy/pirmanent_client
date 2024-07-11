import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pirmanent_client/models/user_model.dart';

String intsToHexString(List<int> integers) {
  return integers.map((int value) {
    return value
        .toRadixString(16)
        .toUpperCase()
        .padLeft(2, '0'); // Convert to 2-digit hex string
  }).join('');
}

List<int> hexStringToInts(String hexString) {
  List<int> integers = [];

  for (int i = 0; i < hexString.length; i += 2) {
    String hexPair = hexString.substring(i, i + 2);
    integers.add(int.parse(hexPair, radix: 16));
  }

  return integers;
}

Future<SimpleKeyPair> retrieveKeyPair(User userData) async {
  final storage = FlutterSecureStorage();

  final privateKeyString = await storage.read(key: userData.email);
  print("priv key from secure storage: $privateKeyString");

  if (privateKeyString == null) {
    throw Exception('Key pair not found');
  }

  final privateKeyBytes = hexStringToInts(privateKeyString);
  final publicKeyBytes = hexStringToInts(userData.publicKey);

  return SimpleKeyPairData(privateKeyBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      type: KeyPairType.ed25519);
}
