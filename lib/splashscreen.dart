import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharpbrains/auth/login_page.dart';
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
  bool stopRolling = false;
  String messageToDisplayForPostLogin = 'Invalid Credential';

  void reroute() async {
    onFired = DateTime.now().millisecondsSinceEpoch / 1000;
    final whereToGo = '/${widget.whereToGo}';
    if (widget.wait == null || widget.wait == false) {
      await Future.delayed(Duration(seconds: secondsToWait));
      routerInstance.go(whereToGo);
    } else if (widget.whereToGo == "registration" && widget.wait == true) {
      await Future.delayed(Duration(milliseconds: 600));
      await ref
          .read(universityNameSaved.future)
          .timeout(
            Duration(seconds: 3),
            onTimeout: () => [
              {'name_of_universities': 'INVALID'},
            ],
          );
      await ref
          .read(coursesOfferedSaved.future)
          .timeout(
            Duration(seconds: 3),
            onTimeout: () => [
              {
                'id': 'null',
                'name_of_uni': 'INVALID',
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
                "uni_name": "INVALID",
                "course_name": "",
                "subject_combination": [""],
              },
            ],
          );

      if (ref.read(coursesOfferedSaved).value == null ||
          ref.read(universityNameSaved).value == null ||
          ref.read(jambSubjectCombinationSaved) == null) {
        ref.invalidate(coursesOfferedSaved);
        ref.invalidate(universityNameSaved);
        ref.invalidate(jambSubjectCombinationSaved);
        routerInstance.pop();

        notifier(
          context: context,
          duration: Duration(seconds: 2),
          bg: mainColor,
          text: 'Recheck network and retry',
        );
      } else {
        routerInstance.go(whereToGo);
      }
    } else if (widget.wait == true && widget.whereToGo == "homepage") {
      //check password here
      final result = await ref
          .read(
            userLoginCheck({
              "email": ref.read(loginUserName),
              "password": ref.read(loginPassword),
            }).future,
          )
          .timeout(
            Duration(seconds: 8),
            onTimeout: () {
              return {"message": "Network Error"};
            },
          );
      // print(result.toString());
      if (result["message"] == "success") {
        routerInstance.go("/${widget.whereToGo}");
        ref.invalidate(userLoginCheck);
        // } else if (result["message"] == "timeout") {
        //   if (mounted && stopRolling == false) {
        //     setState(() {
        //       stopRolling = true;
        //       messageToDisplayForPostLogin = 'Network Error';
        //       // print("yoo ${result}");
        //     });
        //   }
      } else {
        if (mounted && stopRolling == false) {
          setState(() {
            stopRolling = true;
            messageToDisplayForPostLogin = result["message"];
            // print("yoo ${result}");
          });
        }
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
            stopRolling
                ? ElevatedButton(
                    onPressed: () {
                      ref.invalidate(userLoginCheck);
                      return routerInstance.go("/login");
                    },
                    child: Text("Retry"),
                  )
                : CircularProgressIndicator(color: Colors.white),
            Text(
              stopRolling
                  ? messageToDisplayForPostLogin
                  : widget.textToDisplay.trim().isEmpty
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
