import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharpbrains/post-auth/homepage.dart';
import 'package:sharpbrains/utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeIn,
        );
      }
    });
    double shortestSize = MediaQuery.of(context).size.shortestSide;
    return Container(
      // color: Colors.red,
      height: ref.watch(devicesizeY).h,
      width: ref.watch(devicesizeX).w,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(height: shortestSize * 0.066),
          SingleChildScrollView(
            child: InkWell(
              onTap: () => routerInstance.push('/practice'),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: REdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  width: 356.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 75, 80, 185),
                        Color(0xFF8F94FB),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hi, User',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.sp > 21 ? 21 : 21.sp,
                                ),
                              ),

                              Icon(Icons.notifications, color: Colors.white),
                            ],
                          ),
                        ),
                        // Spacer(flex: 1),
                        Row(
                          children: [
                            profilePictureContainer(margin: null, width: null),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Average Test/Exam Score: ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'empty for now',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'empty for now',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 356.w,
            // height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  ref
                      .watch(
                        CoursesForEachDeptSaved,
                      )["${ref.watch(currentSemesterTracker)}_semester_courses"]
                      .length,
                  (index) {
                    List exactSemester = ref.watch(
                      CoursesForEachDeptSaved,
                    )["${ref.watch(currentSemesterTracker)}_semester_courses"];

                    if (index == exactSemester.length - 1) {
                      return Row(
                        children: [
                          customContainer(
                            screenSize: 0.2 * shortestSize,
                            margin: EdgeInsets.only(right: 10),
                            padding: null,
                            color: Color(0x11000000),
                            children: [
                              FutureBuilder(
                                future: Future(() {
                                  return exactSemester;
                                }),
                                builder: (builder, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        SvgPicture.string(
                                          coursesSvgIcon[(coursesSvgIcon.keys
                                              .toList())[index]]!,
                                        ),
                                        Text(
                                          snapshot.data?[index],
                                          // "holder",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Text('Error');
                                  }
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final current = ref.watch(currentSemesterTracker);
                              if (current == "first") {
                                ref
                                        .read(currentSemesterTracker.notifier)
                                        .state =
                                    "second";
                              }
                              if (current == "second") {
                                ref
                                        .read(currentSemesterTracker.notifier)
                                        .state =
                                    "first";
                              }
                            },
                            child: Text('Change Current Semester?'),
                          ),
                        ],
                      );
                    }
                    return customContainer(
                      screenSize: 0.2 * shortestSize,
                      margin: EdgeInsets.only(right: 10),
                      padding: null,
                      color: Color(0x11000000),
                      children: [
                        FutureBuilder(
                          future: Future(() async {
                            return exactSemester;
                          }),
                          builder: (builder, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  SvgPicture.string(
                                    coursesSvgIcon[(coursesSvgIcon.keys
                                        .toList())[index]]!,
                                  ),
                                  Text(
                                    snapshot.data?[index],
                                    // "holder",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            } else {
                              return Text('Error');
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5),
          Expanded(
            child: Row(
              children: [
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly
                    children: List.generate(
                      homepageVerticalIcons.keys.length,
                      (index) => customContainer(
                        screenSize: 0.2 * shortestSize,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        color: Color(0x444E54C8),
                        children: [
                          Text(
                            homepageVerticalIcons.keys.toList()[index],
                            // overflow: TextOverflow.clip,
                            // maxLines: 1,
                            style: TextStyle(fontSize: 15.sp > 15 ? 15 : 15.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-1, -1),
                          color: Color.fromARGB(134, 78, 84, 200),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // child: ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: 4,
            //   itemBuilder: (index, context) => Column(
            //     children: [
            //       Container(
            //         padding: REdgeInsets.symmetric(
            //           vertical: 10,
            //           horizontal: 16,
            //         ),
            //         margin: EdgeInsets.symmetric(horizontal: 1.w),
            //         width: 356.w,
            //         height: 130.h < 109 ? 109 : 130.h,
            //         decoration: BoxDecoration(
            //           color: Color(0xdd4E54C8),
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //         child: Row(
            //           // mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             customContainer(
            //               screenSize: 30,
            //               margin: null,
            //               padding: null,
            //               color: Colors.indigo,
            //               children: [
            //                 Image.asset(
            //                   'assets/images/idpic.jpg',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ],
            //             ),
            //             Spacer(flex: 1),
            //             Column(
            //               mainAxisAlignment:
            //                   MainAxisAlignment.spaceEvenly,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'HEADING',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 15.sp > 15 ? 15 : 15.sp,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //                 Text(
            //                   'data',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ],
            //             ),
            //             Spacer(flex: 10),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

Widget customContainer({
  required double screenSize,

  required EdgeInsetsGeometry? margin,
  required EdgeInsetsGeometry? padding,
  required Color? color,
  required List<Widget> children,
}) {
  return Container(
    clipBehavior: Clip.hardEdge,
    width: screenSize,
    height: screenSize,
    margin: margin ?? EdgeInsets.all(0),
    padding: padding ?? EdgeInsets.all(0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ),
  );
}
