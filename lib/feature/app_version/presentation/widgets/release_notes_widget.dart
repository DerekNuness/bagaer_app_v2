import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReleaseNotesFlyout extends StatefulWidget {
  final String version;
  final String releaseNotes;
  final Widget child; // card clicável

  const ReleaseNotesFlyout({
    super.key,
    required this.version,
    required this.releaseNotes,
    required this.child,
  });

  @override
  State<ReleaseNotesFlyout> createState() => _ReleaseNotesFlyoutState();
}

class _ReleaseNotesFlyoutState extends State<ReleaseNotesFlyout>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _entry;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _entry?.remove();
    super.dispose();
  }

  void _showFlyout() {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    _entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            final t = Curves.easeOutCubic.transform(_controller.value);

            // tamanho final desejado
            final double finalWidth = size.width;   // <<< mantém o MESMO width original
            final double finalHeight = 380;         // altura final (ajuste como quiser)

            // posição animada baseada no width REAL
            final dx = lerpDouble(position.dx, (screenSize.width - finalWidth) / 2, t)!;
            final dy = lerpDouble(position.dy, (screenSize.height - finalHeight) / 2, t)!;

            // tamanho animado
            final w = lerpDouble(size.width, finalWidth, t)!;
            final h = lerpDouble(size.height, finalHeight, t)!;

            return Stack(
              children: [
                // Fundo escurecido
                Opacity(
                  opacity: t * 0.6,
                  child: GestureDetector(
                    onTap: _closeFlyout,
                    child: Container(color: Colors.black),
                  ),
                ),

                // Card animado
                Positioned(
                  left: dx,
                  top: dy,
                  child: Material(
                    borderRadius: BorderRadius.circular(16.r),
                    elevation: 20 * t,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        width: w,
                        height: h,
                        padding: EdgeInsets.symmetric(vertical:  16.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Novidades da versão ${widget.version}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.releaseNotes,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: _closeFlyout, 
                  icon: Icon(
                    Icons.close,
                    size: 30.w,
                  )
                ),
              )
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
    _controller.forward();
  }

  void _closeFlyout() {
    _controller.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _showFlyout,
      child: widget.child,
    );
  }
}