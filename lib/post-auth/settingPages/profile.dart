import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => SettingProfileState();
}

class SettingProfileState extends State<SettingProfile> {
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
