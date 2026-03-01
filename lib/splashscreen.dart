import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
  @override
  void initState() {
    defaultTextToDisplay = widget.textToDisplay.trim().isEmpty
        ? "please wait"
        : widget.textToDisplay;
    super.initState();
    reroute();
  }

  late String defaultTextToDisplay;
  bool takingTooLong = false;
  late double onFired;
  final Color backGround = mainColor;
  Color textColor = Colors.white;
  final int secondsToWait = 2;
  bool stopRolling = false;
  String messageToDisplayForPostLogin = 'Invalid Credential';

  void reroute() async {
    // onFired = DateTime.now().millisecondsSinceEpoch / 1000;
    final whereToGo = '/${widget.whereToGo}';
    if (widget.wait == null || widget.wait == false)
    //for every other normal splash screen
    {
      await Future.delayed(Duration(seconds: secondsToWait));
      routerInstance.go(whereToGo);
    } else if
    //for when signup page is clicked and the user is redirected to thw registration page
    (widget.whereToGo == "registration" && widget.wait == true) {
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
    } else if (widget.wait == true && widget.whereToGo == "homepage")
    //when the login button is clicked and the user want to login
    {
      //check password with the result variable
      final result = await ref
          .read(
            userLoginCheck({
              "email": ref.read(loginUserName),
              "password": ref.read(loginPassword),
            }).future,
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              return {
                "message": "Network Error",
                "yearOfBirth": 0,
                "monthOfBirth": null,
                "dateOfBirth": 0,
                "Universities_name": "invalid",
                "dept_name": "invalid",
                "level": "invalid",
              };
            },
          );
      if (result["message"] == "success")
      //soon as password confirmation is succesful, move on to change the info string and call api for the user courses
      {
        setState(() {
          defaultTextToDisplay = "password Validated, Configuring Dashboard...";
        });
        // print(result);
        ref.read(userEmail.notifier).state = result["email"];
        ref.read(userFirstname.notifier).state = result["first_name"];
        ref.read(userSurname.notifier).state = result["last_name"];
        ref.read(userYearOfBirth.notifier).state = result["yearOfBirth"]
            .toString();
        ref.read(userMonthOfBirth.notifier).state = result["monthOfBirth"];
        ref.read(userDateOfBirth.notifier).state = result["dateOfBirth"]
            .toString();
        ref.read(userUniversityName.notifier).state =
            result["Universities_name"];
        ref.read(userDeptOfStudy.notifier).state = result["dept_name"];
        ref.read(userLevel.notifier).state = result["level"];

        final Map<String, dynamic> temp = await ref
            .read(
              CoursesForEachDept({
                "uni_name": ref.read(userUniversityName),
                "dept_name": ref.read(userDeptOfStudy),
              }).future,
            )
            .timeout(
              Duration(seconds: 5),
              onTimeout: (() {
                return {
                  "uni_name": "invalid",
                  "dept_name": "invalid",
                  "first_semester": ["invalid"],
                  "second_semester": [],
                };
              }),
            );
        ref.read(CoursesForEachDeptSaved.notifier).state = temp;
        print(ref.read(CoursesForEachDeptSaved));

        routerInstance.go("/${widget.whereToGo}");
      } else {
        if (mounted && stopRolling == false) {
          setState(() {
            stopRolling = true;
            messageToDisplayForPostLogin = result["message"];
            // ref.read(textToDisplay.notifier).state = result["message"];
            // print("yoo ${result}");
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // reroute();

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
                      ref.invalidate(CoursesForEachDeptSaved);
                      ref.invalidate(CoursesForEachDeptSaved);
                      ref.invalidate(userLoginCheck);
                      return routerInstance.go("/login");
                    },
                    child: Text("Retry"),
                  )
                : CircularProgressIndicator(color: Colors.white),
            Text(
              // ref.watch(textToDisplay),
              stopRolling ? messageToDisplayForPostLogin : defaultTextToDisplay,

              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// final a = StateProvider((ref) {
//   return '';
// });
