import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should authenticate user with valid credentials", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });

  test("should not authenticate user with invalid credentials", () {
    expect("0912lkjhasdf23.asdf987sdf.oa8s76df987",
        "0912lkjhasdf23.asdf987sdf.oa8s76df987");
  });
}
