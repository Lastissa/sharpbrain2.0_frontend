import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharpbrains/whatsappbubbles.dart';
import 'package:sharpbrains/utils.dart';

class AiChat extends ConsumerStatefulWidget {
  const AiChat({super.key});

  @override
  ConsumerState<AiChat> createState() => _AiChatState();
}

class _AiChatState extends ConsumerState<AiChat> {
  bool navBarActive = false;
  late String userTextToSend;
  bool awaiting = false;
  bool removeLogo = false;
  bool cancelSending = false;
  final ScrollController _autoGoDownForListview = ScrollController();
  // to be able to change when the send icon is active for sending message or not
  final TextEditingController _userInput = TextEditingController();
  String hintText =
      'Type your message...'; //for holding the hinttext and change later if user did not type anything
  void rm() async {
    routerInstance.pop();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoGoDownForListview.hasClients) {
        _autoGoDownForListview.animateTo(
          _autoGoDownForListview.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
        );
      }
    });
  }

  Future<void> send() async {
    scrollToBottom();
    userTextToSend = _userInput.text;
    // print([
    //   ref.read(userAITempChatHolder)['user']?.length ?? 0,
    //   ref.read(userAITempChatHolder)['AI']?.length ?? 0,
    // ]);

    // print(['heeee', ref.read(userAITempChatHolder)]);
    if (userTextToSend.trim().isEmpty) {
      setState(() {
        hintText = "Can't send empty message...";
      });
    } else {
      setState(() {
        removeLogo = true;
        awaiting = true;
        cancelSending = false;
      });
      _userInput.clear();
      if (cancelSending == false) {
        ref.invalidate(
          aiChatResponse,
        ); //to invalidate the previous response so that it can fetch a new response when the user sends a new message, this is important because if we dont invalidate it, it will return the previous response instead of fetching a new one, and that is not what we want, we want to fetch a new response every time the user sends a new message, so we need to invalidate it to make sure it fetches a new response.

        if (cancelSending || !mounted) return;
        final toAdd = await ref
            .read(aiChatResponse({'message': userTextToSend}).future)
            .timeout(
              Duration(seconds: 60),
              onTimeout: () {
                return {
                  'ai_response':
                      'Sorry, the server is taking too long to respond. Please try again later.',
                  'token': 999999,
                };
              },
            );

        if (cancelSending || !mounted) return;
        // print(toAdd);

        String a = await toAdd['ai_response'];
        if (cancelSending || !mounted) return;
        setState(() {
          awaiting = false;
        });
        if (cancelSending || !mounted) return;
        ref.read(userAITempChatHolder.notifier).update((state) {
          return {
            'user': [...?state['user'], userTextToSend],
            'AI': [...?state['AI'], a],
          };
        });
        print([
          ref.read(userAITempChatHolder)['user']?.length ?? 0,
          ref.read(userAITempChatHolder)['AI']?.length ?? 0,
        ]);
        if (toAdd['token'] == 999999) {
          _userInput.text = userTextToSend;
        }
        // setState(() {
        //   refreshPage();
        // });

        //to make sure the listview scroll to the very bottom
        scrollToBottom();
      }
    }
  }
  //to make suere the number of of user text and ai is the same
  //i am commenting it out cos i am so sure the number of user text and ai response will always be the same, if there is a case where it is not the same, then it should be handled in the backend and not here, so i am commenting this out for now, if there is a need for it in the future, then i will just uncomment it and make necessary changes to it
  // int refreshPage() {
  //   if (userTextLenght > aiTextLenght) {
  //     setState(() {
  //       int missing = userTextLenght - aiTextLenght;
  //       for (int i = 0; i < missing; i++) {
  //         holder['AI']!.add('added$i');
  //       }
  //     });
  //   }

  //   return 0;
  // }
  Widget onpressedIcon({
    required double shortestSize,
    required IconData iconData,
    required VoidCallback onTap,
    Color? color,
    bool? isactive = true,
  }) {
    return InkWell(
      onTap: isactive == null ? null : onTap,
      child: Container(
        width: shortestSize * 0.1,
        height: shortestSize * 0.1,
        decoration: BoxDecoration(
          color: color ?? Color(0xFF4E54C8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(iconData, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // refreshPage();
    double navBarMaxWidth = (0.4 * ref.watch(devicesizeX)).w < 136
        ? (0.4 * ref.watch(devicesizeX)).w
        : 136;
    final _shortestSize = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(toolbarHeight: 0),
      body: Stack(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,

            onTap: navBarActive
                ? () => setState(() {
                    navBarActive = false;
                  })
                : null,

            child: Container(
              // color: Colors.red,
              height: ref.watch(devicesizeY).h,
              width: ref.watch(devicesizeX).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 0.98 * ref.watch(devicesizeX).w,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          onpressedIcon(
                            iconData: Icons.navigate_before,
                            onTap: () => rm(),
                            color: Colors.red,
                            shortestSize: _shortestSize,
                          ),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            ref.watch(aiNameHolder),
                            style: TextStyle(
                              color: mainColor,
                              fontSize: _shortestSize * 0.066,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onpressedIcon(
                            iconData: Icons.more_vert,
                            onTap: () {
                              setState(() {
                                navBarActive = true;
                              });
                            },
                            shortestSize: _shortestSize,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        removeLogo == false &&
                            ref.watch(userAITempChatHolder)['user']!.isEmpty
                        ? Center(
                            child: SvgPicture.string(
                              """
                <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>
                  <defs>
                    <linearGradient id='g' x1='0' x2='1'>
                      <stop offset='0' stop-color='#4e54c8'/>
                      <stop offset='1' stop-color='#e0e0e0'/>
                    </linearGradient>
                  </defs>
                  <circle cx='50' cy='50' r='40' fill='url(#g)' opacity='1'/>
                  <text x='50%' y='58%' text-anchor='middle' fill='white' font-family='Arial' font-weight='700'>
                    <tspan font-size='32' dx = '-8'>SB</tspan>
                    <tspan font-size='14' dy='-2' dx='-12'>aI</tspan>
                    <tspan font-size='5' dy='19' dx = '-40'>Customized For You</tspan>
                  </text>
                </svg>
              """,
                              width: ref.watch(devicesizeX).w * 0.6,
                              height: ref.watch(devicesizeX).w * 0.6,
                            ),
                          )
                        : ListView.builder(
                            controller: _autoGoDownForListview,
                            itemCount:
                                ref.watch(userAITempChatHolder)['user']!.isEmpty
                                ? 1
                                : ref
                                          .watch(userAITempChatHolder)['user']
                                          ?.length ??
                                      0,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: ref.watch(devicesizeX).w,
                                child: Column(
                                  children: [
                                    ref
                                            .watch(
                                              userAITempChatHolder,
                                            )['user']!
                                            .isEmpty
                                        ? SizedBox()
                                        : Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Color.fromARGB(
                                                    255,
                                                    191,
                                                    194,
                                                    250,
                                                  ),
                                                  Colors.lightBlueAccent,
                                                ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(devicesizeX).w,
                                            child: SelectableText(
                                              ref.watch(
                                                userAITempChatHolder,
                                              )['user']![index],
                                              textAlign: TextAlign.end,
                                            ),
                                          ),

                                    ref
                                            .watch(
                                              userAITempChatHolder,
                                            )['user']!
                                            .isEmpty
                                        ? SizedBox()
                                        : Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightBlueAccent,
                                                  Color.fromARGB(
                                                    255,
                                                    191,
                                                    194,
                                                    250,
                                                  ),
                                                  Colors.white,
                                                ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(devicesizeX).w,
                                            child: SelectableText(
                                              ref.watch(
                                                userAITempChatHolder,
                                              )['AI']![index],
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                    (awaiting &&
                                                ref
                                                            .watch(
                                                              userAITempChatHolder,
                                                            )['user']!
                                                            .length -
                                                        1 ==
                                                    index) ||
                                            ref
                                                .watch(
                                                  userAITempChatHolder,
                                                )['user']!
                                                .isEmpty
                                        ? Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Color.fromARGB(
                                                    255,
                                                    191,
                                                    194,
                                                    250,
                                                  ),
                                                  Colors.lightBlueAccent,
                                                ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(devicesizeX).w,
                                            child: SelectableText(
                                              userTextToSend,
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        : SizedBox(),
                                    (awaiting &&
                                                ref
                                                            .watch(
                                                              userAITempChatHolder,
                                                            )['user']!
                                                            .length -
                                                        1 ==
                                                    index) ||
                                            ref
                                                .watch(
                                                  userAITempChatHolder,
                                                )['user']!
                                                .isEmpty
                                        ? Container(
                                            color: Colors.transparent,
                                            width: ref.read(devicesizeX),
                                            height:
                                                0.04 * ref.read(devicesizeY),
                                            child: BouncingDots(),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: ref.watch(devicesizeX) * 0.85.w,
                        // height: 100,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _userInput,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration(hintText: hintText),
                        ),
                      ),
                      onpressedIcon(
                        shortestSize: _shortestSize,
                        color: awaiting ? Colors.grey : mainColor,
                        iconData: awaiting ? Icons.stop : Icons.send,
                        onTap: () {
                          if (awaiting) {
                            scrollToBottom();
                            cancelSending = true;
                            ref.read(userAITempChatHolder.notifier).update((
                              state,
                            ) {
                              return {
                                'user': [...?state['user'], userTextToSend],
                                'AI': [
                                  ...?state['AI'],
                                  'You Stopped the response',
                                ],
                              };
                            });
                            awaiting = false;
                            scrollToBottom();
                          } else {
                            cancelSending = false;
                            send();
                            print(ref.watch(userAITempChatHolder));
                          }
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      'AI may be inaccurate, click to consult tutors.\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _shortestSize * 0.040 < 16.45 ? 13 : 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0.01 * ref.watch(devicesizeX),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
              // margin: EdgeInsets.all(10),
              width: navBarActive ? navBarMaxWidth : 0,
              height: navBarActive ? (0.25 * ref.watch(devicesizeY)).h : 0, //,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(ref.read(aiNavBarContent).length, (
                      index,
                    ) {
                      return InkWell(
                        onTap: () {
                          ref.read(aiNavBarContent)[index][1]();
                          setState(() {
                            awaiting = false;
                            removeLogo = false;
                            if (index == 0) {
                              navBarActive = false;
                              _userInput.text = '';
                              userTextToSend = '';
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: navBarActive
                              ? (0.4 * ref.read(devicesizeX)).w
                              : 0,
                          height: navBarActive
                              ? (0.25 *
                                        ref.watch(devicesizeY) /
                                        (ref.watch(aiNavBarContent).length * 2))
                                    .h
                              : 0,
                          child: Center(
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              ref.watch(aiNavBarContent)[index][0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
