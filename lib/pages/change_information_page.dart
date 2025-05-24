import 'package:flutter/material.dart';

class ChangeInformationPage extends StatelessWidget {
  const ChangeInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Information")),
      body: Center(child: Text("Form to change info goes here")),
    );
  }
}