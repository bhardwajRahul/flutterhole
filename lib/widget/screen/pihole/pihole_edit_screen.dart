import 'package:flutter/material.dart';
import 'package:flutterhole_again/model/pihole.dart';
import 'package:flutterhole_again/widget/pihole/single_pihole_view.dart';
import 'package:flutterhole_again/widget/scaffold.dart';

class PiholeEditScreen extends StatelessWidget {
  final Pihole pihole;

  const PiholeEditScreen({Key key, @required this.pihole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        titleString: 'Editing ${pihole.title}',
        body: SinglePiholeView(
          original: pihole,
        ));
  }
}
