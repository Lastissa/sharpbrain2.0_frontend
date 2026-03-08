import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharpbrains/utils.dart';

class SettingProfile extends ConsumerStatefulWidget {
  const SettingProfile({super.key});

  @override
  ConsumerState<SettingProfile> createState() => SettingProfileState();
}

class SettingProfileState extends ConsumerState<SettingProfile> {
  @override
  void initState() {
    super.initState();
    emailController.text = ref.read(userEmail);
    firstNameController.text = ref.read(userFirstname);
    surNameController.text = ref.read(userSurname);
    uniController.text = ref.read(userUniversityName);
    deptController.text = ref.read(userDeptOfStudy);
    levelController.text = ref.read(userLevel);
  }

  final emailController = TextEditingController();
  final emailPasswordController = TextEditingController();
  final emailOtpBoxController = TextEditingController();
  final firstNameController = TextEditingController();
  final firstNamePassowrdController = TextEditingController();
  final surNameController = TextEditingController();
  final surNamePassowrdController = TextEditingController();

  final uniController = TextEditingController();
  final deptController = TextEditingController();
  final levelController = TextEditingController();

  bool emailEditMode = false; //this is for when the edit mode is active or not
  bool firstNameEditMode =
      false; //this is for when the edit mode is active or not
  bool surNameEditMode =
      false; //this is for when the edit mode is active or not
  bool uniEditMode = false; //this is for when the edit mode is active or not
  bool deptEditMode = false; //this is for when the edit mode is active or not
  bool levelEditMode = false; //this is for when the edit mode is active or not

  bool emailAskPassword =
      false; // this is to ask for password from the user to be sure they are the owner of the account
  bool firstNameAskPassword =
      false; // this is to ask for password from the user to be sure they are the owner of the account
  bool surNameAskPassword =
      false; // this is to ask for password from the user to be sure they are the owner of the account
  bool emailPasswordConfirmPressed =
      false; //to check wether the user have pressed the suffix button in the password textformfeild
  bool emailVerification =
      false; // to wether the otp textformfeild should pop up or just stay down
  bool firstNamePasswordConfirmPressed =
      false; //for monitoring the state of the firstname password
  bool surNamePasswordConfirmPressed =
      false; //for monitoring the state of the firstname password
  void message({required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 900),
        content: Center(
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(text),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // width: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.invalidate(emailValidated);
    final deptWatcher = ref.watch(coursesOfferedSaved);
    final uniWatcher = ref.read(universityNameSaved);
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: mainColor),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(),
              width: ref.watch(devicesizeX).w,
              height: 0.65 * ref.watch(devicesizeY).h,
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.only(left: 20.r),
              child: Text(
                "Take note of the following precautions and quidelines.\n>\t\tChanging your email changes your primary way to login.\n>\t\tUpdate made here will be universal to your profile.",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: ref.watch(devicesizeX).w,
            height: 0.65 * ref.watch(devicesizeY).h,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
              right: 20.r,
              left: 20.r,
              bottom: 20.r,
              top: ref.read(devicesizeY) * 0.3.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => routerInstance.pop(),
                    icon: Icon(Icons.swipe_left_alt_rounded, color: mainColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PROFILE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp.clamp(18, 24),
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                  //begining of the first row of editables
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "Email",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: emailController,
                          onChanged: (value) {
                            if (emailPasswordConfirmPressed) {
                              setState(() {
                                emailPasswordConfirmPressed = false;
                              });
                            }
                            if (emailVerification) {
                              setState(() {
                                emailVerification = false;
                              });
                            }
                            ref.invalidate(emailValidated);
                          },
                          style: TextStyle(
                            fontStyle: emailEditMode
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          autofocus: emailEditMode ? true : false,
                          readOnly: !emailEditMode,
                          decoration: InputDecoration(
                            border: emailEditMode
                                ? UnderlineInputBorder()
                                : InputBorder.none,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 195),
                        padding: EdgeInsets.all(8.r),
                        width: 0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                        decoration: BoxDecoration(
                          color: emailEditMode
                              ? Color.fromARGB(28, 78, 84, 200)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: emailEditMode
                              ? [
                                  InkWell(
                                    onTap: () {
                                      if (emailController.text
                                              .toUpperCase()
                                              .trim() ==
                                          ref.read(userEmail).toUpperCase()) {
                                        ElegantNotification(
                                          description: Text(
                                            "Email Still The Same",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                            color: mainColor,
                                          ),
                                        ).show(context);
                                        return;
                                      } else if (!emailController.text
                                          .toLowerCase()
                                          .contains("@gmail.com")) {
                                        ElegantNotification(
                                          description: Text("Email Not Valid"),
                                          icon: Icon(
                                            Icons.notification_important,
                                            color: mainColor,
                                          ),
                                        ).show(context);
                                        return;
                                      }

                                      setState(() {
                                        emailAskPassword = true;
                                      });
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      emailController.text = ref.read(
                                        userEmail,
                                      );
                                      setState(() {
                                        emailEditMode = false;
                                        emailAskPassword = false;
                                        emailVerification = false;
                                        emailPasswordController.text = "";
                                        emailOtpBoxController.text = "";
                                        emailPasswordConfirmPressed = false;
                                        ref.invalidate(emailValidated);
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        emailEditMode = true;
                                        firstNameEditMode = false;
                                        surNameEditMode = false;
                                        uniEditMode = false;
                                        deptEditMode = false;
                                        levelEditMode = false;
                                        firstNameAskPassword = false;
                                        firstNamePasswordConfirmPressed = false;
                                        firstNamePassowrdController.text = "";
                                        firstNameController.text = ref.read(
                                          userFirstname,
                                        );
                                        surNamePasswordConfirmPressed = false;
                                        surNamePassowrdController.text = "";
                                        surNameController.text = ref.read(
                                          userSurname,
                                        );
                                      });
                                    },
                                    child: Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                  //this is not seen as part of the row because it is dependent on wether the user want to change thier mail or not(password)
                  emailAskPassword && !emailVerification
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: emailPasswordController,
                                onChanged: (value) {
                                  setState(() {
                                    emailPasswordConfirmPressed = false;
                                  });
                                },

                                // keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: mainColor,
                                  ),
                                  suffix: emailPasswordConfirmPressed
                                      ? FutureBuilder(
                                          future: Future(() async {
                                            //first thing first, check for password,if it dey valid but before you check , make sure there is no typo in the new email
                                            if (!emailController.text
                                                .toLowerCase()
                                                .contains("@gmail.com")) {
                                              return [
                                                {
                                                  "message":
                                                      "emailcontroller.text.invalid",
                                                },
                                                "emailcontroller.text.invalid",
                                              ];
                                            }
                                            final data = await ref
                                                .refresh(
                                                  passwordChecker({
                                                    "email": ref.read(
                                                      userEmail,
                                                    ),
                                                    "password":
                                                        emailPasswordController
                                                            .text,
                                                  }).future,
                                                )
                                                .timeout(
                                                  Duration(
                                                    seconds:
                                                        8 +
                                                        ref.read(renderHoldUp),
                                                  ),
                                                  onTimeout: () {
                                                    return {
                                                      "message":
                                                          "emailchecker timeout",
                                                    };
                                                  },
                                                );
                                            if (data["message"] == "correct") {
                                              final Map emailExist = await ref
                                                  .refresh(
                                                    emailChecker({
                                                      "email": emailController
                                                          .text
                                                          .trim(),
                                                    }).future,
                                                  )
                                                  .timeout(
                                                    Duration(
                                                      seconds:
                                                          8 +
                                                          ref.read(
                                                            renderHoldUp,
                                                          ),
                                                    ),
                                                    onTimeout: () => {
                                                      "message":
                                                          "email Availability timeout",
                                                    },
                                                  );
                                              if (emailExist["message"] ==
                                                  "False") {
                                                await ref
                                                    .refresh(
                                                      otp({
                                                        "email": emailController
                                                            .text,
                                                      }).future,
                                                    )
                                                    .timeout(
                                                      Duration(
                                                        seconds:
                                                            5 +
                                                            ref.read(
                                                              renderHoldUp,
                                                            ),
                                                      ),
                                                    );
                                                return [data, emailExist];
                                              }
                                              return [data, emailExist];
                                            }
                                            return [
                                              data,
                                              {"message": "ignore"},
                                            ];
                                          }),
                                          builder: (builder, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return SizedBox(
                                                width:
                                                    0.2 *
                                                    ref.read(devicesizeX).w,
                                                child:
                                                    LinearProgressIndicator(),
                                              );
                                            } else if (snapshot.hasData) {
                                              // print("heyyy ${snapshot.data}");
                                              if (snapshot
                                                      .data?[0]["message"] ==
                                                  //checking if the user new email is valid before even sendong any request to my server
                                                  "emailcontroller.text.invalid") {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                      setState(() {
                                                        emailPasswordConfirmPressed =
                                                            false;
                                                      });
                                                      ElegantNotification(
                                                        description: Text(
                                                          "Invalid Email",
                                                        ),
                                                        icon: Icon(Icons.info),
                                                      ).show(context);
                                                    });
                                              } else if (snapshot
                                                      .data?[0]["message"] ==
                                                  "correct") {
                                                if (!emailVerification) {
                                                  WidgetsBinding.instance.addPostFrameCallback((
                                                    _,
                                                  ) {
                                                    if (snapshot
                                                            .data![1]["message"] ==
                                                        "False") {
                                                      ElegantNotification(
                                                        toastDuration: Duration(
                                                          seconds: 4,
                                                        ),
                                                        description: Text(
                                                          "Password verified, Enter otp sent to the new email to complete verification",
                                                        ),
                                                        icon: Icon(
                                                          Icons
                                                              .notification_important,
                                                        ),
                                                      ).show(context);
                                                      setState(() {
                                                        emailVerification =
                                                            true;
                                                      });
                                                    } else if (snapshot
                                                            .data![1]["message"] ==
                                                        "True") {
                                                      ElegantNotification(
                                                        description: Text(
                                                          "Password verified But email is taken",
                                                        ),
                                                        icon: Icon(
                                                          Icons
                                                              .notification_important,
                                                        ),
                                                      ).show(context);
                                                    } else {
                                                      ElegantNotification(
                                                        description: Text(
                                                          "email verification Timeout",
                                                        ),
                                                        icon: Icon(
                                                          Icons
                                                              .notification_important,
                                                        ),
                                                      ).show(context);
                                                    }
                                                  });
                                                }
                                                return Icon(Icons.verified);
                                              } else if (snapshot
                                                      .data?[0]["message"] ==
                                                  "incorrect") {
                                                if (!emailVerification) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        ElegantNotification(
                                                          description: Text(
                                                            "Password is ${snapshot.data?[0]["message"]}",
                                                          ),
                                                          icon: Icon(
                                                            Icons
                                                                .notification_important,
                                                          ),
                                                        ).show(context);
                                                      });
                                                }
                                                return Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                );
                                              } else {
                                                if (!emailVerification) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        ElegantNotification(
                                                          description: Text(
                                                            "Server down",
                                                          ),
                                                          icon: Icon(
                                                            Icons
                                                                .notification_important,
                                                          ),
                                                        ).show(context);

                                                        setState(() {
                                                          emailPasswordConfirmPressed =
                                                              false;
                                                        });
                                                      });
                                                }
                                                return Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                );
                                              }
                                            }
                                            return SizedBox();
                                          },
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              emailPasswordConfirmPressed =
                                                  true;
                                            });
                                          },
                                          child: Text('Confirm'),
                                        ),
                                  hintText: 'Confirm Password',
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  //this is still not part of the main table, it is just for email verification
                  AnimatedCrossFade(
                    firstChild: ref.watch(emailValidated)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10.r),
                                width: ref.read(devicesizeX) * 0.3.w,
                                child: LinearProgressIndicator(),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsetsDirectional.only(top: 10.r),
                                width: 0.3 * ref.read(devicesizeX).w,
                                height: 0.1 * ref.read(devicesizeY).h,

                                child: TextFormField(
                                  controller: emailOtpBoxController,
                                  maxLength: 5,
                                  onChanged: (value) async {
                                    if (value.length ==
                                            ref
                                                .read(otpValue)
                                                .toString()
                                                .length &&
                                        ref.read(otpValue) != 0) {
                                      if (ref.read(otpValue).toString() ==
                                          value.trim()) {
                                        ref
                                                .read(emailValidated.notifier)
                                                .state =
                                            true;

                                        final data = await ref
                                            .refresh(
                                              emailUpdate({
                                                "old_email": ref.read(
                                                  userEmail,
                                                ),
                                                "new_email": emailController
                                                    .text
                                                    .trim(),
                                                "password":
                                                    emailPasswordController.text
                                                        .trim(),
                                              }).future,
                                            )
                                            .timeout(
                                              Duration(
                                                seconds:
                                                    8 + ref.read(renderHoldUp),
                                              ),
                                            );
                                        ref.invalidate(emailValidated);

                                        if (data != null &&
                                            data["message"] == "success" &&
                                            mounted) {
                                          ElegantNotification(
                                            description: Text(
                                              "New email verified and updated successfully",
                                            ),
                                            icon: Icon(
                                              Icons.verified,
                                              color: mainColor,
                                            ),
                                          ).show(context);
                                          ref.read(userEmail.notifier).state =
                                              emailController.text.trim();
                                          setState(() {
                                            ref.invalidate(emailValidated);
                                            emailVerification = false;
                                            emailEditMode = false;
                                            emailOtpBoxController.text = "";
                                            emailPasswordController.text = "";
                                            emailPasswordConfirmPressed = false;
                                            emailAskPassword = false;
                                            emailOtpBoxController.text = "";
                                          });
                                        } else {
                                          ElegantNotification(
                                            description: Text(
                                              "Something Went Wrong, Please try again",
                                            ),
                                            icon: Icon(Icons.error),
                                          );
                                        }
                                      } else {
                                        ElegantNotification(
                                          description: Text(
                                            "Wrong OTP.\nRecheck and retype the otp",
                                          ),
                                          icon: Icon(
                                            Icons.verified,
                                            color: mainColor,
                                          ),
                                        ).show(context);
                                      }
                                    }
                                  },
                                  cursorHeight: 0,
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white30,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    filled: true,
                                    focusColor: Colors.white30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    secondChild: Center(child: SizedBox()),
                    crossFadeState: emailVerification
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 400),
                    firstCurve: Curves.easeOut,
                  ),
                  //begining of the second row of editables
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "First Name",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            fontStyle: firstNameEditMode
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          autofocus: firstNameEditMode ? true : false,
                          controller: firstNameController,
                          readOnly: !firstNameEditMode,
                          decoration: InputDecoration(
                            border: firstNameEditMode
                                ? UnderlineInputBorder()
                                : InputBorder.none,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 195),
                        padding: EdgeInsets.all(8.r),
                        width: 0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                        decoration: BoxDecoration(
                          color: firstNameEditMode
                              ? Color.fromARGB(28, 78, 84, 200)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: firstNameEditMode
                              ? [
                                  InkWell(
                                    onTap: () {
                                      if (firstNameController.text
                                              .trim()
                                              .toLowerCase() ==
                                          ref
                                              .read(userFirstname)
                                              .toLowerCase()) {
                                        ElegantNotification(
                                          description: Text(
                                            "No change in First Name dectected",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                      } else if (firstNameController.text
                                          .trim()
                                          .isEmpty) {
                                        ElegantNotification(
                                          description: Text(
                                            "FirstName Field Cannot Be Empty",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                      } else {
                                        setState(() {
                                          firstNameEditMode = true;
                                          firstNameAskPassword = true;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        firstNameEditMode = false;
                                        firstNameAskPassword = false;
                                        firstNameController.text = ref.read(
                                          userFirstname,
                                        );
                                        firstNamePasswordConfirmPressed = false;
                                        firstNamePassowrdController.text = "";
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        firstNameEditMode = true;
                                        emailEditMode = false;
                                        emailAskPassword = false;
                                        emailPasswordController.text = "";
                                        emailController.text = ref.read(
                                          userEmail,
                                        );
                                        surNameEditMode = false;
                                        uniEditMode = false;
                                        deptEditMode = false;
                                        levelEditMode = false;
                                        firstNameAskPassword = false;
                                        firstNamePasswordConfirmPressed = false;

                                        surNameAskPassword = false;
                                        surNamePasswordConfirmPressed = false;
                                        surNamePasswordConfirmPressed = false;
                                        surNamePassowrdController.text = "";
                                        surNameController.text = ref.read(
                                          userSurname,
                                        );
                                      });
                                    },
                                    child: Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                  //this is not seen as part of the row cos it is depedanr on wether the user want to change their first name or not
                  AnimatedCrossFade(
                    firstChild: SizedBox(),
                    secondChild: TextFormField(
                      controller: firstNamePassowrdController,
                      onChanged: (value) {
                        if (firstNamePasswordConfirmPressed) {
                          setState(() {
                            firstNamePasswordConfirmPressed = false;
                          });
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: mainColor),

                        hintText: "Confirm Password",
                        suffix: firstNamePasswordConfirmPressed
                            ? FutureBuilder(
                                future: Future(() async {
                                  //the holder is just there incase the user keep fumbling with the firstname controller, i mean when the future request is almost beign made, using controlller.text is risky
                                  if (!firstNameEditMode) {
                                    return {"message": "cancelled"};
                                  } //this is for safety check incase the user calcel the request while it is about running
                                  //the safety chechk will barely work but omo, just leave this one only
                                  String firstNameHolder = firstNameController
                                      .text
                                      .trim();
                                  if (!firstNamePasswordConfirmPressed) {
                                    return {"message": "cancelled"};
                                  }
                                  final data = await ref
                                      .read(
                                        firstNameUpdate({
                                          "email": ref.read(userEmail),
                                          "password":
                                              firstNamePassowrdController.text,
                                          "new_first_name": firstNameHolder
                                              .trim(),
                                        }).future,
                                      )
                                      .timeout(
                                        Duration(
                                          seconds: 8 + ref.read(renderHoldUp),
                                        ),
                                        onTimeout: () {
                                          return {"message": "timeout"};
                                        },
                                      );
                                  if (!firstNamePasswordConfirmPressed) {
                                    return {"message": "cancelled"};
                                  }
                                  if (data["message"] == "success" &&
                                      firstNamePasswordConfirmPressed) {
                                    ref.read(userFirstname.notifier).state =
                                        firstNameHolder.toUpperCase();
                                  }

                                  return data;
                                }),
                                builder: (builder, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 0.2 * ref.read(devicesizeX).w,
                                      child: LinearProgressIndicator(),
                                    );
                                    ;
                                  } else if (snapshot.hasData) {
                                    print(snapshot.data);

                                    if (snapshot.data["message"] == "success" &&
                                        firstNameEditMode == true &&
                                        mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            setState(() {
                                              firstNameEditMode = false;
                                              firstNameAskPassword = false;
                                              firstNamePasswordConfirmPressed =
                                                  false;
                                            });

                                            firstNameController.text = ref.read(
                                              userFirstname,
                                            );

                                            firstNamePassowrdController.text =
                                                "";
                                            ElegantNotification(
                                              description: Text(
                                                "First Name Updated Successfuly",
                                              ),
                                              icon: Icon(
                                                Icons.notification_important,
                                                color: mainColor,
                                              ),
                                            ).show(context);
                                          });

                                      return Icon(
                                        Icons.verified,
                                        color: mainColor,
                                      );
                                    } else if (snapshot.data["message"] ==
                                            "incorrect_password" &&
                                        firstNameEditMode == true &&
                                        mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            ElegantNotification(
                                              description: Text(
                                                "Incorrect Password",
                                              ),
                                              icon: Icon(Icons.warning),
                                            ).show(context);
                                            setState(() {
                                              firstNamePasswordConfirmPressed =
                                                  false;
                                            });
                                            firstNamePassowrdController.text =
                                                "";
                                          });
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    } else if (snapshot.data["message"] ==
                                            "no user" &&
                                        firstNameEditMode == true) {
                                      WidgetsBinding.instance.addPostFrameCallback((
                                        _,
                                      ) {
                                        ElegantNotification(
                                          description: Text(
                                            "Email does not exist; normmaly it is impossible for you to be seeing this notification",
                                          ),
                                          icon: Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                        ).show(context);
                                        setState(() {
                                          firstNamePasswordConfirmPressed =
                                              false;
                                        });
                                      });
                                      return Icon(
                                        Icons.error_rounded,
                                        color: Colors.red,
                                      );
                                    } else {
                                      WidgetsBinding.instance.addPostFrameCallback((
                                        _,
                                      ) {
                                        ElegantNotification(
                                          description: Text(
                                            "Update Not successful\n${snapshot.data["message"]}",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                        setState(() {
                                          firstNamePasswordConfirmPressed =
                                              false;
                                        });
                                      });
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    }
                                  }
                                  return SizedBox();
                                },
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    firstNamePasswordConfirmPressed = true;
                                  });
                                },
                                child: Text("Confirm"),
                              ),
                      ),
                    ),
                    crossFadeState: firstNameAskPassword
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 170),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeOut,
                  ),

                  //begining of the third row of editables
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "Surname",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            fontStyle: surNameEditMode
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          autofocus: surNameEditMode ? true : false,
                          controller: surNameController,
                          readOnly: !surNameEditMode,
                          decoration: InputDecoration(
                            border: surNameEditMode
                                ? UnderlineInputBorder()
                                : InputBorder.none,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 195),
                        padding: EdgeInsets.all(8.r),
                        width: 0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                        decoration: BoxDecoration(
                          color: surNameEditMode
                              ? Color.fromARGB(28, 78, 84, 200)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: surNameEditMode
                              ? [
                                  InkWell(
                                    onTap: () {
                                      if (surNameController.text
                                              .trim()
                                              .toLowerCase() ==
                                          ref.read(userSurname).toLowerCase()) {
                                        ElegantNotification(
                                          description: Text(
                                            "No change in Surname dectected",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                      } else if (surNameController.text
                                          .trim()
                                          .isEmpty) {
                                        ElegantNotification(
                                          description: Text(
                                            "Surname Field Cannot Be Empty",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                      } else {
                                        setState(() {
                                          surNameEditMode = true;
                                          surNameAskPassword = true;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        surNameEditMode = false;
                                        surNameAskPassword = false;
                                        surNameController.text = ref.read(
                                          userFirstname,
                                        );
                                        surNamePasswordConfirmPressed = false;
                                        surNamePassowrdController.text = "";
                                        surNameController.text = ref.read(
                                          userSurname,
                                        );
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        surNameEditMode = true;
                                        emailEditMode = false;
                                        emailAskPassword = false;
                                        emailPasswordController.text = "";
                                        emailController.text = ref.read(
                                          userEmail,
                                        );
                                        firstNameEditMode = false;
                                        uniEditMode = false;
                                        deptEditMode = false;
                                        levelEditMode = false;
                                        surNameAskPassword = false;
                                        surNamePasswordConfirmPressed = false;
                                        firstNameAskPassword = false;
                                        firstNamePasswordConfirmPressed = false;
                                        firstNamePassowrdController.text = "";
                                        firstNameController.text = ref.read(
                                          userFirstname,
                                        );
                                      });
                                    },
                                    child: Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                  //this is not seen as part of the row cos it is depedanr on wether the user want to change their first name or not
                  AnimatedCrossFade(
                    firstChild: SizedBox(),
                    secondChild: TextFormField(
                      controller: surNamePassowrdController,
                      onChanged: (value) {
                        if (surNamePasswordConfirmPressed) {
                          setState(() {
                            surNamePasswordConfirmPressed = false;
                          });
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: mainColor),

                        hintText: "Confirm Password",
                        suffix: surNamePasswordConfirmPressed
                            ? FutureBuilder(
                                future: Future(() async {
                                  //the holder is just there incase the user keep fumbling with the firstname controller, i mean when the future request is almost beign made, using controlller.text is risky
                                  if (!surNameEditMode) {
                                    return {"message": "cancelled"};
                                  } //this is for safety check incase the user calcel the request while it is about running
                                  //the safety chechk will barely work but omo, just leave this one only
                                  String surNameHolder = surNameController.text
                                      .trim();
                                  if (!surNamePasswordConfirmPressed) {
                                    return {"message": "cancelled"};
                                  }
                                  final data = await ref
                                      .read(
                                        surNameUpdate({
                                          "email": ref.read(userEmail),
                                          "password":
                                              surNamePassowrdController.text,
                                          "new_sur_name": surNameHolder.trim(),
                                        }).future,
                                      )
                                      .timeout(
                                        Duration(
                                          seconds: 8 + ref.read(renderHoldUp),
                                        ),
                                        onTimeout: () {
                                          return {"message": "timeout"};
                                        },
                                      );
                                  if (!surNamePasswordConfirmPressed) {
                                    return {"message": "cancelled"};
                                  }

                                  if (data["message"] == "success" &&
                                      surNamePasswordConfirmPressed) {
                                    ref.read(userSurname.notifier).state =
                                        surNameHolder.toUpperCase();
                                  }

                                  return data;
                                }),
                                builder: (builder, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 0.2 * ref.read(devicesizeX).w,
                                      child: LinearProgressIndicator(),
                                    );
                                    ;
                                  } else if (snapshot.hasData) {
                                    print(snapshot.data);

                                    if (snapshot.data["message"] == "success" &&
                                        surNameEditMode == true &&
                                        mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            setState(() {
                                              surNameEditMode = false;
                                              surNameAskPassword = false;
                                              surNamePasswordConfirmPressed =
                                                  false;
                                            });

                                            surNameController.text = ref.read(
                                              userSurname,
                                            );

                                            surNamePassowrdController.text = "";
                                            ElegantNotification(
                                              description: Text(
                                                "Surname Updated Successfuly",
                                              ),
                                              icon: Icon(
                                                Icons.notification_important,
                                                color: mainColor,
                                              ),
                                            ).show(context);
                                          });

                                      return Icon(
                                        Icons.verified,
                                        color: mainColor,
                                      );
                                    } else if (snapshot.data["message"] ==
                                            "incorrect_password" &&
                                        surNameEditMode == true &&
                                        mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            ElegantNotification(
                                              description: Text(
                                                "Incorrect Password",
                                              ),
                                              icon: Icon(Icons.warning),
                                            ).show(context);
                                            setState(() {
                                              surNamePasswordConfirmPressed =
                                                  false;
                                            });
                                            surNamePassowrdController.text = "";
                                          });
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    } else if (snapshot.data["message"] ==
                                            "no user" &&
                                        surNameEditMode == true &&
                                        mounted) {
                                      WidgetsBinding.instance.addPostFrameCallback((
                                        _,
                                      ) {
                                        ElegantNotification(
                                          description: Text(
                                            "Email does not exist; normmaly it is impossible for you to be seeing this notification",
                                          ),
                                          icon: Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                        ).show(context);
                                      });
                                      return Icon(
                                        Icons.error_rounded,
                                        color: Colors.red,
                                      );
                                    } else {
                                      WidgetsBinding.instance.addPostFrameCallback((
                                        _,
                                      ) {
                                        ElegantNotification(
                                          description: Text(
                                            "${snapshot.data["message"]}\nUpdate Not successful",
                                          ),
                                          icon: Icon(
                                            Icons.notification_important,
                                          ),
                                        ).show(context);
                                        setState(() {
                                          surNamePasswordConfirmPressed = false;
                                        });
                                      });
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    }
                                  }
                                  return SizedBox();
                                },
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    surNamePasswordConfirmPressed = true;
                                  });
                                },
                                child: Text("Confirm"),
                              ),
                      ),
                    ),
                    crossFadeState: surNameAskPassword
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 170),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeOut,
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "Level",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: levelEditMode
                            ? DropdownButtonFormField(
                                isExpanded: true,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                ),
                                items: List.generate(aspirantOrLevel.length, (
                                  index,
                                ) {
                                  return DropdownMenuItem(
                                    value: aspirantOrLevel[index],
                                    child: Text(aspirantOrLevel[index]),
                                  );
                                }),
                                onChanged: (value) {},
                              )
                            : TextFormField(
                                style: TextStyle(fontStyle: FontStyle.italic),
                                controller: levelController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 195),
                        padding: EdgeInsets.all(8.r),
                        width: 0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                        decoration: BoxDecoration(
                          color: levelEditMode
                              ? Color.fromARGB(28, 78, 84, 200)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: levelEditMode
                              ? [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (levelEditMode) {
                                          levelEditMode = false;
                                        } else if (!levelEditMode) {
                                          levelEditMode = true;
                                        }
                                      });

                                      message(text: "Level Updated");
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (levelEditMode) {
                                          levelEditMode = false;
                                        } else if (!levelEditMode) {
                                          levelEditMode = true;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        levelEditMode = true;
                                        emailEditMode = false;
                                        emailAskPassword = false;
                                        emailPasswordConfirmPressed = false;
                                        emailVerification = false;
                                        emailOtpBoxController.text = "";
                                        emailPasswordController.text = "";
                                        emailController.text = ref.read(
                                          userEmail,
                                        );
                                        firstNameEditMode = false;
                                        surNameEditMode = false;
                                        uniEditMode = false;
                                        deptEditMode = false;
                                        firstNamePasswordConfirmPressed = false;
                                        firstNamePassowrdController.text = "";
                                        firstNameController.text = ref.read(
                                          userFirstname,
                                        );
                                        surNamePasswordConfirmPressed = false;
                                        surNamePassowrdController.text = "";
                                        surNameController.text = ref.read(
                                          userSurname,
                                        );
                                      });
                                    },
                                    child: Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                  //begining of the fifth row of editables
                  AnimatedCrossFade(
                    firstChild: uniWatcher.when(
                      data: (data) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                "University",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: uniEditMode
                                  ? DropdownButtonFormField(
                                      isExpanded: true,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                      items: List.generate(data!.length, (
                                        index,
                                      ) {
                                        return DropdownMenuItem(
                                          value:
                                              data[index]["name_of_universities"],
                                          child: Text(
                                            data[index]["name_of_universities"],
                                          ),
                                        );
                                      }),
                                      onChanged: (value) {},
                                    )
                                  : TextFormField(
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                      controller: uniController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 195),
                              padding: EdgeInsets.all(8.r),
                              width:
                                  0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                              decoration: BoxDecoration(
                                color: uniEditMode
                                    ? Color.fromARGB(28, 78, 84, 200)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: uniEditMode
                                    ? [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (uniEditMode) {
                                                uniEditMode = false;
                                              } else if (!deptEditMode) {
                                                uniEditMode = true;
                                              }
                                            });

                                            message(
                                              text: "University Name Updated",
                                            );
                                          },
                                          child: Icon(
                                            Icons.save,
                                            color: mainColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (uniEditMode) {
                                                uniEditMode = false;
                                              } else if (!uniEditMode) {
                                                uniEditMode = true;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ]
                                    : [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              uniEditMode = true;
                                              emailEditMode = false;
                                              emailAskPassword = false;
                                              emailPasswordConfirmPressed =
                                                  false;
                                              emailVerification = false;
                                              emailOtpBoxController.text = "";
                                              emailPasswordController.text = "";
                                              emailController.text = ref.read(
                                                userEmail,
                                              );
                                              firstNameEditMode = false;
                                              surNameEditMode = false;
                                              deptEditMode = false;
                                              levelEditMode = false;
                                              firstNameAskPassword = false;
                                              firstNamePasswordConfirmPressed =
                                                  false;
                                              firstNamePassowrdController.text =
                                                  "";
                                              firstNameController.text = ref
                                                  .read(userFirstname);
                                              surNamePasswordConfirmPressed =
                                                  false;
                                              surNamePassowrdController.text =
                                                  "";
                                              surNameController.text = ref.read(
                                                userSurname,
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: mainColor,
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, Stack) {
                        // print(Stack);
                        return SizedBox();
                      },
                      loading: () => SizedBox(),
                    ),
                    secondChild: Center(child: SizedBox()),

                    crossFadeState: uniWatcher.isLoading
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 400),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeOut,
                  ),
                  //begining of the sixth row of editables
                  AnimatedCrossFade(
                    firstChild: deptWatcher.when(
                      data: (data) {
                        List<String> mapToUse = [];
                        for (Map i in data!) {
                          if (ref.read(userUniversityName).toUpperCase() ==
                              i["name_of_uni"]) {
                            mapToUse = List<String>.from(i["courses_offered"]);
                          }
                        }
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                "Dept",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: deptEditMode
                                  ? DropdownButtonFormField(
                                      isExpanded: true,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                      items: List.generate(mapToUse.length, (
                                        index,
                                      ) {
                                        return DropdownMenuItem(
                                          value: mapToUse[index],
                                          child: Text(mapToUse[index]),
                                        );
                                      }),
                                      onChanged: (value) {},
                                    )
                                  : TextFormField(
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                      controller: deptController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 195),
                              padding: EdgeInsets.all(8.r),
                              width:
                                  0.2 * ref.read(devicesizeX).w.clamp(300, 500),
                              decoration: BoxDecoration(
                                color: deptEditMode
                                    ? Color.fromARGB(28, 78, 84, 200)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: deptEditMode
                                    ? [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (deptEditMode) {
                                                deptEditMode = false;
                                              } else if (!deptEditMode) {
                                                deptEditMode = true;
                                              }
                                            });

                                            message(text: "Dept Updated");
                                          },
                                          child: Icon(
                                            Icons.save,
                                            color: mainColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (deptEditMode) {
                                                deptEditMode = false;
                                              } else if (!deptEditMode) {
                                                deptEditMode = true;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ]
                                    : [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              deptEditMode = true;
                                              emailEditMode = false;
                                              emailAskPassword = false;
                                              emailPasswordConfirmPressed =
                                                  false;
                                              emailVerification = false;
                                              emailOtpBoxController.text = "";
                                              emailPasswordController.text = "";
                                              emailController.text = ref.read(
                                                userEmail,
                                              );
                                              firstNameEditMode = false;
                                              surNameEditMode = false;
                                              uniEditMode = false;
                                              levelEditMode = false;
                                              firstNameAskPassword = false;
                                              firstNamePasswordConfirmPressed =
                                                  false;
                                              emailEditMode = false;
                                              emailAskPassword = false;
                                              emailPasswordConfirmPressed =
                                                  false;
                                              emailVerification = false;
                                              emailOtpBoxController.text = "";
                                              emailPasswordController.text = "";
                                              emailController.text = ref.read(
                                                userEmail,
                                              );
                                              firstNameEditMode = false;
                                              surNameEditMode = false;
                                              uniEditMode = false;
                                              levelEditMode = false;
                                              firstNameAskPassword = false;
                                              firstNamePasswordConfirmPressed =
                                                  false;
                                              firstNamePassowrdController.text =
                                                  "";
                                              firstNameController.text = ref
                                                  .read(userFirstname);
                                              surNamePasswordConfirmPressed =
                                                  false;
                                              surNamePassowrdController.text =
                                                  "";
                                              surNameController.text = ref.read(
                                                userSurname,
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: mainColor,
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, stack) {
                        // print(stack);
                        return SizedBox();
                      },
                      loading: () => SizedBox(),
                    ),
                    secondChild: Center(child: SizedBox()),

                    crossFadeState: deptWatcher.isLoading
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 400),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeOut,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final emailValidated = StateProvider<bool>((ref) {
  return false;
});
