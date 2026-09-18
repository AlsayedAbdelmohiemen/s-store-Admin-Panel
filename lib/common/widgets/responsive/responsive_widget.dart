import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';

/// Widget for rendering different layouts based on screen size (Desktop, Tablet, Mobile)
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.desktop,
    required this.tablet,
    required this.mobile,
  });

  final Widget desktop;
  final Widget tablet;
  final Widget mobile;

  /// Helper checks
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= SSizes.desktopScreenSize;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= SSizes.tabletScreenSize &&
      MediaQuery.of(context).size.width < SSizes.desktopScreenSize;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < SSizes.tabletScreenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= SSizes.desktopScreenSize) {
          return desktop;
        } else if (constraints.maxWidth >= SSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
