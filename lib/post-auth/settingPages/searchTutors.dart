import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Searchtutors extends StatefulWidget {
  const Searchtutors({super.key});

  @override
  State<Searchtutors> createState() => _SearchtutorsState();
}

class _SearchtutorsState extends State<Searchtutors> {
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
