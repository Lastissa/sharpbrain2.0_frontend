import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharpbrains/post-auth/databasePage/databasepage.dart';
import 'package:sharpbrains/post-auth/historyPages/historypage.dart';
import 'package:sharpbrains/post-auth/home.dart';
import 'package:sharpbrains/post-auth/settingPages/settingpage.dart';
import 'package:sharpbrains/utils.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Databasepage(),
    Historypage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double shortestSize = MediaQuery.of(context).size.shortestSide;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        // backgroundColor: Color(0xFF2Ed4C5),
        body: IndexedStack(index: _currentIndex, children: _pages),
        //AI mode. will be more like a chatbot interface with layover interface that can be laid over other pages aprtially with a cancel buttom
        floatingActionButton: InkWell(
          onTap: () => routerInstance.push('/aichat'),
          child: Container(
            width: shortestSize * 0.1,
            height: shortestSize * 0.1,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(Icons.chat, color: Colors.white),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          width: ref.watch(devicesizeX).r,
        ),
      ),
    );
  }
}

//Using my own phone as example for screen size

//to simpify the reusage of screenutil container

class CustomNavBar extends ConsumerStatefulWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.width,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final double width;

  @override
  ConsumerState<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 4, right: 4, left: 4),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_iconData.length, (index) {
          return Container(
            padding: EdgeInsets.only(bottom: 0.008 * ref.watch(devicesizeX).w),
            width: ref.watch(devicesizeX) * 0.2.w,
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onTap(index),
              child: Icon(
                _iconData[index],
                color: Colors.white,
                size: widget.width * 0.08 <= 24.88
                    ? widget.width * 0.08
                    : 24.88,
              ),
            ),
          );
        }),
      ),
    );
  }
}

List<IconData> _iconData = [
  Icons.home,
  Icons.dashboard_customize,
  Icons.history,
  Icons.settings,
];

Widget profilePictureContainer({
  required EdgeInsetsGeometry? margin,
  required double? width,
}) {
  return Container(
    clipBehavior: Clip.hardEdge,
    margin: margin ?? EdgeInsets.only(right: 10),
    width: width ?? 90.h,
    height: width ?? 90.h,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: mainColor,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 93, 101, 236),
          offset: Offset(2, 1),
        ),
        BoxShadow(
          color: Color.fromARGB(255, 67, 73, 185),
          offset: Offset(-2, 2),
        ),
      ],
    ),
    child: FutureBuilder(
      future: Future(() async {
        await Future.delayed(Duration(seconds: 3));
        return true;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasData) {
          // return Image.asset('assets/images/profile.jfif', fit: BoxFit.cover);
          return SizedBox();
        } else {
          return Center(child: Text('Error'));
        }
      },
    ),
  );
}
