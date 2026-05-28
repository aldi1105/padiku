import 'package:flutter/material.dart';

class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.slideOffset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, opacity, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: slideOffset, end: 0.0),
          duration: duration,
          curve: Curves.easeOut,
          builder: (context, offset, _) {
            // Apply delay manually by checking if the animation should have started
            // Actually, for entrance animations on page load, a Delay with Future.delayed
            // or just simple TweenAnimationBuilder is easier.
            // But TweenAnimationBuilder starts immediately.
            
            // To support delay, we can use an AnimatedOpacity/AnimatedContainer after a Future.delayed
            // or just use this simple version if no delay needed.
            // For a "lightweight" feel, I'll stick to a slightly simpler version or add delay support.
            
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, offset),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}

/// A version of FadeInSlide that supports a start delay.
class DelayedFadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;

  const DelayedFadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.slideOffset = 30.0,
  });

  @override
  State<DelayedFadeInSlide> createState() => _DelayedFadeInSlideState();
}

class _DelayedFadeInSlideState extends State<DelayedFadeInSlide> {
  bool _start = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _start ? 1.0 : 0.0,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: AnimatedPadding(
        padding: EdgeInsets.only(top: _start ? 0 : widget.slideOffset),
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
