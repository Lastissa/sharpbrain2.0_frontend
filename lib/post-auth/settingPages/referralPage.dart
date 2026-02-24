import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Referralpage extends StatefulWidget {
  const Referralpage({super.key});

  @override
  State<Referralpage> createState() => ReferralpageState();
}

class ReferralpageState extends State<Referralpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          IconButton(
            onPressed: () => routerInstance.pop(),
            icon: Icon(Icons.reset_tv_rounded),
          ),
        ],
      ),
    );
  }
}
