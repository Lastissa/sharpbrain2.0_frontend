import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Becomeatutor extends StatefulWidget {
  const Becomeatutor({super.key});

  @override
  State<Becomeatutor> createState() => _BecomeatutorState();
}

class _BecomeatutorState extends State<Becomeatutor> {
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
