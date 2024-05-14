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
