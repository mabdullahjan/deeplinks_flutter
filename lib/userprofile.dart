import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Userprofile extends StatefulWidget {
  final String? profileid;
  const Userprofile({super.key, required this.profileid});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('profile Id : ${widget.profileid}')),
    );
  }
}
