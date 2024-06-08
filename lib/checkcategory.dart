import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CheckCategory extends StatefulWidget {
  final String? id;
  const CheckCategory({super.key, this.id});

  @override
  State<CheckCategory> createState() => _CheckCategoryState();
}

class _CheckCategoryState extends State<CheckCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ID ${widget.id}')),
    );
  }
}
