import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharpbrains/utils.dart';

class Splashscreen extends ConsumerStatefulWidget {
  final String whereToGo;
  final String textToDisplay;
  //use '' for default words

  final bool? wait;

  const Splashscreen({
    super.key,
    required this.whereToGo,
    required this.textToDisplay,
    required this.wait,
  });

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  String defaultTextToDisplay = 'please wait';
  bool takingTooLong = false;
  late double onFired;
  final Color backGround = mainColor;
  final Color textColor = Colors.white;
  final int secondsToWait = 2;

  void reroute() async {
    onFired = DateTime.now().millisecondsSinceEpoch / 1000;
    // print(onFired);
    final whereToGo = '/${widget.whereToGo}';
    if (widget.wait == null || widget.wait == false) {
      await Future.delayed(Duration(seconds: secondsToWait));
      routerInstance.go(whereToGo);
    } else {
      // takingTooLong = true;

      await Future.delayed(Duration(milliseconds: 600));
      await ref
          .read(universityNameSaved.future)
          .timeout(
            Duration(seconds: 3),
            onTimeout: () => [
              {'name_of_universities': 'invalid'},
            ],
          );
      await ref
          .read(coursesOfferedSaved.future)
          .timeout(
            Duration(seconds: 3),
            onTimeout: () => [
              {
                'id': 'null',
                'name_of_uni': 'invalid',
                'courses_offered': [''],
              },
            ],
          );
      await ref
          .read(jambSubjectCombinationSaved.future)
          .timeout(
            Duration(seconds: 3),
            onTimeout: () => [
              {
                "uni_name": "invalid",
                "course_name": "",
                "subject_combination": [""],
              },
            ],
          );

      if (ref.read(coursesOfferedSaved).value == null ||
          ref.read(universityNameSaved).value == null ||
          ref.read(jambSubjectCombinationSaved) == null) {
        routerInstance.pop();
        ref.invalidate(coursesOfferedSaved);
        ref.invalidate(universityNameSaved);
        ref.invalidate(jambSubjectCombinationSaved);
        notifier(
          context: context,
          duration: Duration(seconds: 2),
          bg: mainColor,
          text: 'Recheck network and retry',
        );
      } else {
        routerInstance.go(whereToGo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    reroute();

    return Scaffold(
      backgroundColor: backGround,
      body: Container(
        width: ref.watch(devicesizeX).w,
        height: ref.watch(devicesizeY).h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.string(
                '''<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>
<defs><linearGradient id='g' x1='0' x2='1'><stop offset='0' stop-color='#ffff'/><stop offset='1' stop-color='#e0e0e0'/></linearGradient></defs>
<circle cx='50' cy='50' r='40' fill='url(#g)' opacity='0.18'/>
<text x='50%' y='55%' font-size='36' text-anchor='middle' fill='white' font-family='Arial' font-weight='700'>SB</text>
</svg>''',
                height: 100,
              ),
            ),
            // Text('Sharp Brains', style: TextStyle(color: textColor)),
            const SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            Text(
              widget.textToDisplay.trim().isEmpty
                  ? defaultTextToDisplay
                  : widget.textToDisplay,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
