import 'package:flutter/material.dart';

//AI GENERATED Bouncing Dots Widget, used in AiChat when the bot is "typing" a response. It creates a simple animation of three dots bouncing up and down to indicate that the bot is processing the user's input and generating a response. The animation is achieved using Flutter's AnimationController and Tween classes, with a staggered start for each dot to create a more dynamic effect.
//COME BACK TP UNDERSTAND THIS BETTER, I DONT FULLY GET IT YET, BUT IT WORKS AND LOOKS GOOD SO IM NOT TOO WORRIED ABOUT IT. I THINK I GET THE GENERAL IDEA OF HOW IT WORKS THOUGH, ITS JUST THE DETAILS OF THE ANIMATION THAT I DONT FULLY UNDERSTAND YET. I THINK IT HAS TO DO WITH THE CURVE AND THE TWEEN, BUT IM NOT 100% SURE HOW THEY WORK TOGETHER TO CREATE THE BOUNCING EFFECT. ILL HAVE TO PLAY AROUND WITH IT MORE TO FULLY UNDERSTAND IT.
class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key});

  @override
  _BouncingDotsState createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(
        reverse: true,
      ); //the .. mean performing a request istead of returning void, it gives back the return on the data itself ; like mylist.add() returns void but mylist..add() returns the list itself after adding the element
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -10).animate(
        CurvedAnimation(
          parent: controller,
          // Curves.easeInOut makes the transition at the top and bottom
          // feel smooth and "springy" instead of a hard robotic stop.
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Stagger the start of each dot
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat();
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
