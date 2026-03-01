import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharpbrains/post-auth/homepage.dart';

import 'package:sharpbrains/utils.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingspageState();
}

class _SettingspageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ref.watch(devicesizeY).h,
      width: ref.watch(devicesizeX).w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          profilePictureContainer(
            margin: EdgeInsets.only(top: 20),
            width: null,
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),
          element(
            text: 'Profile',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/SettingProfile'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'Test / Exam Analysis',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/Testexamanalysis'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'Ai Configuration',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/aiconfig'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'Search  Tutors',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/searchtutors'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'Become A Tutor',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/becomeatutor'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'See Our Other Apps',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/seeourotherapp'),
            height: ref.watch(devicesizeY),
          ),
          horizontalBreak(width: ref.watch(devicesizeX)),

          element(
            text: 'about Developer',
            iconData: Icons.person,
            ontap: () => routerInstance.push('/referralpage'),
            height: ref.watch(devicesizeY),
          ),

          ElevatedButton(
            onPressed: () {
              ref.invalidate(userUniversityName);
              ref.invalidate(userDeptOfStudy);
              ref.invalidate(userAITempChatHolder);

              routerInstance.go('/splashscreenSignOut');
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

Widget horizontalBreak({required double width}) {
  return Container(
    width: 0.9 * width.w,
    height: 2,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: AlignmentGeometry.centerLeft,
        end: AlignmentGeometry.centerRight,
        // stops: [0, 0.2, 1],
        colors: [Colors.transparent, mainColor, Colors.transparent],
      ),
    ),
  );
}

Widget element({
  required double height,
  required String text,
  required IconData iconData,
  required VoidCallback ontap,
}) {
  return InkWell(
    onTap: ontap,
    child: Padding(
      padding: EdgeInsetsGeometry.only(
        left: 15,
        top: 0.01 * height.h,
        bottom: 0.01 * height.h,
      ),
      child: Row(children: [Icon(iconData), Text(text)]),
    ),
  );
}
