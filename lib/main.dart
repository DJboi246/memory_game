import 'dart:math';
import 'dart:async';
import 'package:spring/spring.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  int score = 0;
  int best = 0;
  int place = 0;
  var order = [];
  var ran = Random();
  SpringController springController1 = SpringController();
  SpringController springController2 = SpringController();
  SpringController springController3 = SpringController();
  SpringController springController4 = SpringController();
  bool showing = true;

  void show() {
    order.add(ran.nextInt(4) + 1);
    // ignore: avoid_types_as_parameter_names
    order.asMap().forEach((index, num) {
      Timer(Duration(seconds: index), () {
        if (num == 1) {
          springController1.play(motion: Motion.play);
        }
        if (num == 2) {
          springController2.play(motion: Motion.play);
        }
        if (num == 3) {
          springController3.play(motion: Motion.play);
        }
        if (num == 4) {
          springController4.play(motion: Motion.play);
        }
        if (index + 1 == order.length) {
          showing = false;
        }
      });
    });
  }

  void reset() {
    setState(() {
      score = 0;
      place = 0;
      order = [];
      Timer(const Duration(seconds: 1), () => show());
    });
  }

  void press(pressednum) {
    if (showing == false) {
      if (pressednum == order[place]) {
        place += 1;
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("You Lost!"),
                content: const Text("You have lost.\nDo you want to play again?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        reset();
                      },
                      child: const Text("Sure"))
                ],
              );
            },
            barrierDismissible: false);
      }
      if (place == order.length) {
        place = 0;
        showing = true;
        setState(() {
          score += 1;
          if (score > best) {
            best = score;
          }
        });
        Timer(const Duration(seconds: 1), () => show());
      }
    }
  }

  void startshow() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    show();
  }

  @override
  void initState() {
    startshow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("score: $score", style: const TextStyle(fontSize: 40)),
          Text("best: $best", style: const TextStyle(fontSize: 20)),
          GridView(
            padding: const EdgeInsets.all(50),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 50, crossAxisSpacing: 50),
            children: [
              Spring.bubbleButton(
                  springController: springController1,
                  onTap: () => press(1),
                  child: Container(
                    color: const Color.fromRGBO(255, 113, 91, 1),
                  )),
              Spring.bubbleButton(
                  springController: springController2,
                  onTap: () => press(2),
                  child: Container(
                    color: const Color.fromRGBO(47, 82, 224, 0.95),
                  )),
              Spring.bubbleButton(
                  springController: springController3,
                  onTap: () => press(3),
                  child: Container(color: const Color.fromRGBO(249, 203, 64, 0.98))),
              Spring.bubbleButton(
                  springController: springController4,
                  onTap: () => press(4),
                  child: Container(
                    color: const Color.fromRGBO(68, 175, 105, 0.93),
                  )),
            ],
          ),
        ],
      ),
    ));
  }
}
