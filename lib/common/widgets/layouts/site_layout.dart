import 'package:flutter/material.dart';
import 'headers/header.dart';
import 'sidebars/sidebar.dart';
import '../responsive/responsive_widget.dart';

class SSiteLayout extends StatefulWidget {
  const SSiteLayout({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  State<SSiteLayout> createState() => _SSiteLayoutState();
}

class _SSiteLayoutState extends State<SSiteLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(child: SSidebar()),
      appBar: ResponsiveWidget.isDesktop(context)
          ? null
          : SHeader(scaffoldKey: _scaffoldKey),
      body: ResponsiveWidget(
        desktop: Row(
          children: [
            const SSidebar(),
            Expanded(
              child: Column(
                children: [
                  SHeader(scaffoldKey: _scaffoldKey),
                  Expanded(
                    child: SelectionArea(
                      child: widget.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        tablet: SelectionArea(child: widget.body),
        mobile: SelectionArea(child: widget.body),
      ),
    );
  }
}
