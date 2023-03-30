import 'package:flutter/material.dart';


class ContentText extends StatelessWidget {
  final String text;
  const ContentText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: const TextStyle(fontSize: 16),);
  }
}
