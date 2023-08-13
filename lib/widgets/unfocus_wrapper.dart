import 'package:flutter/material.dart';

// Helps to close keyboard or un-focus text fields
class UnFocusWrapper extends StatelessWidget {
  const UnFocusWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
