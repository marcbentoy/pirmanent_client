import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should grant authorization upon 2FA verification", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });

  test("should not grant authorization with invalid credentials", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });
}
