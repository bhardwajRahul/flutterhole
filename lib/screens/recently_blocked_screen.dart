import 'package:flutter/material.dart';
import 'package:sterrenburg.github.flutterhole/models/dashboard/default_scaffold.dart';
import 'package:sterrenburg.github.flutterhole/models/dashboard/recently_blocked.dart';

class RecentlyBlockedScreen extends StatefulWidget {
  @override
  _RecentlyBlockedScreenState createState() => _RecentlyBlockedScreenState();
}

class _RecentlyBlockedScreenState extends State<RecentlyBlockedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Recently Blocked',
      body: RecentlyBlocked(),
    );
  }
}
