import 'dart:async';

import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendCodeTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onResend;
  final TextStyle onSecondsRemainigStyle;
  final TextStyle textButtonStyle;

  const ResendCodeTimer({
    super.key,
    this.initialSeconds = 60,
    required this.onResend,
    required this.onSecondsRemainigStyle,
    required this.textButtonStyle,
  });

  @override
  State<ResendCodeTimer> createState() => _ResendCodeTimerState();
}

class _ResendCodeTimerState extends State<ResendCodeTimer> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = widget.initialSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _handleResend() {
    widget.onResend();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(microseconds: 5),
      child: _secondsRemaining > 0
      ? SizedBox(
          key: const ValueKey('timer'),
          height: 48.h,
          child: Center(
            child: Text(
              'Reenviar código em $_secondsRemaining segundos',
              style: widget.onSecondsRemainigStyle,
              textAlign: TextAlign.center,
            ),
          ),
        )
      : TextButton(
          key: const ValueKey('button'),
          onPressed: _handleResend,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.transparent,
          ),
          child: Text(
            'Toque para reenviar o código',
            style: widget.textButtonStyle,
          ),
        ),
    );
  }
}