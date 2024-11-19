import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {

    return kIsWeb ? desktop
        : mobile;
  }
}

class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget small;
  final Widget? medium;
  final Widget? medium2;
  final Widget large;
  const ResponsiveLayoutWidget({
    super.key,
    required this.small,
    this.medium,
    this.medium2,
    required this.large,
  });

  // screen sizes
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 1000 &&
          MediaQuery.sizeOf(context).width > 918;

  static bool isTablet2(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 918 &&
          MediaQuery.sizeOf(context).width > 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1000;

  @override
  Widget build(BuildContext context) {

    return isDesktop(context) ? large
    : isTablet(context) ? medium2 ?? small : isTablet2(context) ? medium ?? small
    : small ;
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     if (constraints.maxWidth >= 1000) {
    //       return large;
    //     } else if (constraints.maxWidth >= 600) {
    //       return medium ?? small;
    //     } else {
    //       return small;
    //     }
    //   },
    // );
  }
}
