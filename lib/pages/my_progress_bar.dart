import 'dart:async';
import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/custom_proress_bar.dart';
import '../common/sizes.dart';
import '../common/colors.dart';

class MyProgressBar extends StatefulWidget {
  const MyProgressBar({super.key});

  @override
  State<MyProgressBar> createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> with TickerProviderStateMixin {
  late var width = MediaQuery.of(context).size.width * 0.9;
  Timer? _pauseTime1;
  Timer? _startTime1;
  Timer? _pauseTime2;
  Timer? _startTime2;

  late Tween<double> _decorationAnimationTween;
  late Animation<double> _decorationAnimation;
  late AnimationController _decorationAnimationController;

  late Tween<double> _barSizeAnimationTween;
  late Animation<double> _barSizeAnimation;
  late AnimationController _barSizeAnimationController;

  void startAnimations() {
    _decorationAnimationController.forward();
    _barSizeAnimationController.forward();
  }

  @override
  void initState() {
    setupProgressBarAnimation();
    setupProgressBarDecorationAnimation();
    schedulePauseTime();
    super.initState();
  }

  void setupProgressBarDecorationAnimation() {
    _decorationAnimationTween = Tween(begin: spaceBetweenStrock, end: 0);
    _decorationAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _decorationAnimation = _decorationAnimationTween.animate(_decorationAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _decorationAnimationController.repeat();
      })
      ..addListener(() => setState(() {}));
  }

  void setupProgressBarAnimation() {
    _barSizeAnimationTween = Tween(begin: 0, end: 100);
    _barSizeAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _barSizeAnimation = _barSizeAnimationTween.animate(_barSizeAnimationController)
      ..addListener(() => setState(() {}));
  }

  Future<void> schedulePauseTime() async {
    var firstRandomSecond = Random().nextInt(5) + 1;
    var secondRandomSecond = Random().nextInt(5) + 9;

    _pauseTime1 = Timer(
      Duration(seconds: firstRandomSecond),
      () => _barSizeAnimationController.stop(),
    );

    _startTime1 = Timer(
      Duration(seconds: firstRandomSecond + 3),
      () => _barSizeAnimationController.forward(),
    );

    _pauseTime2 = Timer(
      Duration(seconds: secondRandomSecond),
      () => _barSizeAnimationController.stop(),
    );

    _startTime2 = Timer(
      Duration(seconds: secondRandomSecond + 3),
      () => _barSizeAnimationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                CustomPaint(
                  painter: CustomProgressBar(animationOffset: _decorationAnimation.value),
                  size: Size(calculateProgressBarWidth(), 20),
                ),
                Container(
                  width: calculateBackgroundWidth(),
                  height: 20,
                  color: progressBarBackgrounColor,
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(onPressed: restart, child: const Text('Start/restart'))
      ],
    );
  }

  calculateBackgroundWidth() => width - _barSizeAnimation.value / 100 * width;

  calculateProgressBarWidth() => width * _barSizeAnimation.value / 100;

  void restart() {
    cancelTimers();
    schedulePauseTime();
    setupProgressBarAnimation();
    setupProgressBarDecorationAnimation();
    startAnimations();
  }

  void cancelTimers() {
    _pauseTime1?.cancel();
    _startTime1?.cancel();
    _pauseTime2?.cancel();
    _startTime2?.cancel();
  }

  @override
  void dispose() {
    _decorationAnimationController.dispose();
    _barSizeAnimationController.dispose();
    super.dispose();
  }
}
