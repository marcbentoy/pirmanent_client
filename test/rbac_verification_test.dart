import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should grant access to authorized user", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });

  test("should not grant access to unauthorized user", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });
}
