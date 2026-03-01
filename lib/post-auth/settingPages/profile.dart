import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final emailKey = GlobalKey<FormFieldState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();
  final uniController = TextEditingController();
  final deptController = TextEditingController();
  final levelController = TextEditingController();

  bool emailEditMode = false;
  bool firstNameEditMode = false;
  bool surNameEditMode = false;
  bool uniEditMode = false;
  bool deptEditMode = false;
  bool levelEditMode = false;
  String? uniTempHolderTillUserPressSave;
  String? deptTempHolderTillUserPressSave;
  String? levelTempHolderTillUserPressSave;

  bool emailConfirmPassword = false;

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
    final deptWatcher = ref.watch(coursesOfferedSaved);
    final uniWatcher = ref.read(universityNameSaved);
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(toolbarHeight: 0),
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
                          key: emailKey,
                          controller: emailController,

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
                                          ref.read(userEmail).toUpperCase())
                                        return;
                                      else if (!emailController.text.contains(
                                        "@gmail.com",
                                      ))
                                        return;

                                      setState(() {
                                        emailConfirmPassword = true;
                                      });
                                      // message(text: "Email Updated");
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (emailEditMode) {
                                          emailEditMode = false;
                                          emailConfirmPassword = false;
                                          passwordController.text = "";
                                        } else if (!emailEditMode) {
                                          emailEditMode = true;
                                        }
                                      });
                                    },
                                    child: emailEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (emailEditMode) {
                                          emailEditMode = false;
                                        } else if (!emailEditMode) {
                                          emailEditMode = true;
                                          firstNameEditMode = false;
                                          surNameEditMode = false;
                                          uniEditMode = false;
                                          deptEditMode = false;
                                          levelEditMode = false;
                                        }
                                      });
                                    },
                                    child: emailEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                  //this is not seen as part of the row because it is dependent on wether the user want to change thier mail or not
                  emailConfirmPassword
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  // border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: mainColor,
                                  ),
                                  suffix: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Confirm'),
                                  ),
                                  hintText: 'Confirm Password',
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
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
                                      setState(() {
                                        if (firstNameEditMode) {
                                          firstNameEditMode = false;
                                        } else if (!firstNameEditMode) {
                                          firstNameEditMode = true;
                                        }
                                      });

                                      message(text: "Email Updated");
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (firstNameEditMode) {
                                          firstNameEditMode = false;
                                        } else if (!firstNameEditMode) {
                                          firstNameEditMode = true;
                                        }
                                      });
                                    },
                                    child: firstNameEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (firstNameEditMode) {
                                          firstNameEditMode = false;
                                        } else if (!firstNameEditMode) {
                                          firstNameEditMode = true;
                                          emailEditMode = false;
                                          emailConfirmPassword = false;
                                          passwordController.text = "";
                                          surNameEditMode = false;
                                          uniEditMode = false;
                                          deptEditMode = false;
                                          levelEditMode = false;
                                        }
                                      });
                                    },
                                    child: firstNameEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
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
                                      setState(() {
                                        if (surNameEditMode) {
                                          surNameEditMode = false;
                                        } else if (!surNameEditMode) {
                                          surNameEditMode = true;
                                        }
                                      });

                                      message(text: "Surname Updated");
                                    },
                                    child: Icon(Icons.save, color: mainColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (surNameEditMode) {
                                          surNameEditMode = false;
                                        } else if (!surNameEditMode) {
                                          surNameEditMode = true;
                                        }
                                      });
                                    },
                                    child: surNameEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (surNameEditMode) {
                                          surNameEditMode = false;
                                        } else if (!surNameEditMode) {
                                          surNameEditMode = true;
                                          emailEditMode = false;
                                          emailConfirmPassword = false;
                                          passwordController.text = "";
                                          firstNameEditMode = false;
                                          uniEditMode = false;
                                          deptEditMode = false;
                                          levelEditMode = false;
                                        }
                                      });
                                    },
                                    child: surNameEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),

                  //begining of the fourth row of editables
                  uniWatcher.when(
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
                                    items: List.generate(data!.length, (index) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        child: uniEditMode
                                            ? Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.edit,
                                                color: mainColor,
                                              ),
                                      ),
                                    ]
                                  : [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (uniEditMode) {
                                              uniEditMode = false;
                                            } else if (!uniEditMode) {
                                              uniEditMode = true;
                                              emailEditMode = false;
                                              emailConfirmPassword = false;
                                              passwordController.text = "";
                                              firstNameEditMode = false;
                                              surNameEditMode = false;
                                              deptEditMode = false;
                                              levelEditMode = false;
                                            }
                                          });
                                        },
                                        child: uniEditMode
                                            ? Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )
                                            : Icon(
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
                      print(Stack);
                      return SizedBox();
                    },
                    loading: () => SizedBox(),
                  ),
                  //begining of the fifth row of editables
                  deptWatcher.when(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        child: deptEditMode
                                            ? Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.edit,
                                                color: mainColor,
                                              ),
                                      ),
                                    ]
                                  : [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (deptEditMode) {
                                              deptEditMode = false;
                                            } else if (!deptEditMode) {
                                              deptEditMode = true;
                                              emailEditMode = false;
                                              emailConfirmPassword = false;
                                              passwordController.text = "";
                                              firstNameEditMode = false;
                                              surNameEditMode = false;
                                              uniEditMode = false;
                                              levelEditMode = false;
                                            }
                                          });
                                        },
                                        child: deptEditMode
                                            ? Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )
                                            : Icon(
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
                      print(stack);
                      return SizedBox();
                    },
                    loading: () => SizedBox(),
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
                                    child: levelEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ]
                              : [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (levelEditMode) {
                                          levelEditMode = false;
                                        } else if (!levelEditMode) {
                                          levelEditMode = true;
                                          emailEditMode = false;
                                          emailConfirmPassword = false;
                                          passwordController.text = "";
                                          firstNameEditMode = false;
                                          surNameEditMode = false;
                                          uniEditMode = false;
                                          deptEditMode = false;
                                        }
                                      });
                                    },
                                    child: levelEditMode
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : Icon(Icons.edit, color: mainColor),
                                  ),
                                ],
                        ),
                      ),
                    ],
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
