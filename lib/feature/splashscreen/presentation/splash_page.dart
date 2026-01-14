import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;

  const SplashPage({
    super.key,
    required this.onAnimationFinished,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Lottie.asset(
          'assets/animations/Splash-2.json',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.contain,
          controller: _controller,
          onLoaded: (composition) async {
            _controller..duration = composition.duration..forward();

            await Future.delayed(composition.duration);

            if (mounted) {
              widget.onAnimationFinished();
            }
          },
        ),
      ),
    );
  }
}