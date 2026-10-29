import 'dart:math' as math;
import 'package:flutter/material.dart';

class PageCurlWidget extends StatefulWidget {
  final Widget child;
  final Key pageKey;

  const PageCurlWidget({
    super.key,
    required this.child,
    required this.pageKey,
  });

  @override
  State<PageCurlWidget> createState() => _PageCurlWidgetState();
}

class _PageCurlWidgetState extends State<PageCurlWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Widget? _oldChild;
  Widget? _currentChild;

  @override
  void initState() {
    super.initState();
    _currentChild = widget.child;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void didUpdateWidget(covariant PageCurlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageKey != widget.pageKey) {
      _oldChild = oldWidget.child;
      _currentChild = widget.child;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubic,
        ).value;

        if (_controller.isCompleted || _oldChild == null) {
          return _currentChild ?? const SizedBox.shrink();
        }

        final angleY = (1.0 - progress) * (-math.pi / 2.1);
        final angleZ = (1.0 - progress) * -0.14;
        final scaleVal = 0.88 + (0.12 * progress);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Underlying Old Background Page
            _oldChild!,

            /// Turning Page with 3D Perspective & Paper Curl Shadow
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..rotateY(angleY)
                ..rotateZ(angleZ),
              alignment: Alignment.bottomRight,
              child: ScaleTransition(
                scale: AlwaysStoppedAnimation(scaleVal),
                alignment: Alignment.bottomRight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _currentChild!,

                    /// Dynamic Paper Curl Corner Shadow Layer
                    if (progress < 0.98)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withAlpha((190 * (1.0 - progress)).toInt()),
                              Colors.black.withAlpha((70 * (1.0 - progress)).toInt()),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
