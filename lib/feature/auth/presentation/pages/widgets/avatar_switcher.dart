
// import 'package:bagaer/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AvatarPickerFlySwap extends StatefulWidget {
//   final List<String> assetPaths;
//   final ValueChanged<String>? onSelected;

//   const AvatarPickerFlySwap({
//     super.key,
//     required this.assetPaths,
//     this.onSelected,
//   });

//   @override
//   State<AvatarPickerFlySwap> createState() => _AvatarPickerFlySwapState();
// }

// class _AvatarPickerFlySwapState extends State<AvatarPickerFlySwap>
//     with SingleTickerProviderStateMixin {
//   late List<String> avatars;

//   final _centerKey = GlobalKey();

//   late final List<GlobalKey> _slotKeys;

//   late final AnimationController _controller;

//   OverlayEntry? _overlay;
//   int? _hiddenSlotIndex;
//   bool _animating = false;

//   // dados do voo atual
//   Rect? _startRect;
//   Rect? _endRect;
//   String? _flyingAsset;

//   @override
//   void initState() {
//     super.initState();
//     avatars = List.of(widget.assetPaths);
//     _slotKeys = List.generate(avatars.length, (_) => GlobalKey());

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _overlay?.remove();
//     super.dispose();
//   }

//   Rect _rectFromKey(GlobalKey key) {
//     final box = key.currentContext!.findRenderObject() as RenderBox;
//     final topLeft = box.localToGlobal(Offset.zero);
//     return topLeft & box.size;
//   }

//   void _removeOverlay() {
//     _overlay?.remove();
//     _overlay = null;
//   }

//   Future<void> _flySwapToCenter(int slotIndex) async {
//     if (_animating) return;
//     if (slotIndex == 0) return;

//     setState(() => _animating = true);

//     // garante que não tem overlay antigo
//     _removeOverlay();

//     _flyingAsset = avatars[slotIndex];

//     _startRect = _rectFromKey(_slotKeys[slotIndex]);
//     _endRect = _rectFromKey(_centerKey);

//     setState(() => _hiddenSlotIndex = slotIndex);

//     final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

//     _overlay = OverlayEntry(
//       builder: (context) {
//         return AnimatedBuilder(
//           animation: curve,
//           builder: (_, __) {
//             final t = curve.value;

//             final r = Rect.lerp(_startRect!, _endRect!, t)!;

//             return Positioned(
//               left: r.left,
//               top: r.top,
//               width: r.width,
//               height: r.height,
//               child: IgnorePointer(
//                 child: _FlyingAvatar(asset: _flyingAsset!),
//               ),
//             );
//           },
//         );
//       },
//     );

//     Overlay.of(context, rootOverlay: true).insert(_overlay!);

//     _controller.reset();
//     await _controller.forward();

//     // swap real
//     setState(() {
//       final tmp = avatars[0];
//       avatars[0] = avatars[slotIndex];
//       avatars[slotIndex] = tmp;

//       _hiddenSlotIndex = null;
//       _animating = false;
//     });

//     widget.onSelected?.call(avatars[0]);

//     _removeOverlay();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final center = avatars[0];

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _CenterAvatar(
//           key: _centerKey,
//           asset: center,
//           dimWhenAnimating: _animating,
//         ),
//         18.verticalSpaceFromWidth,
//         Wrap(
//           spacing: 15.w,
//           runSpacing: 15.w,
//           alignment: WrapAlignment.center,
//           children: List.generate(avatars.length - 1, (i) {
//             final slotIndex = i + 1;
//             final isHidden = _hiddenSlotIndex == slotIndex;

//             return Opacity(
//               opacity: isHidden ? 0 : 1,
//               child: _OptionAvatar(
//                 key: _slotKeys[slotIndex],
//                 asset: avatars[slotIndex],
//                 enabled: !_animating,
//                 onTap: () => _flySwapToCenter(slotIndex),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

// class _CenterAvatar extends StatelessWidget {
//   final String asset;
//   final bool dimWhenAnimating;

//   const _CenterAvatar({
//     super.key,
//     required this.asset,
//     required this.dimWhenAnimating,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedScale(
//       duration: const Duration(milliseconds: 220),
//       curve: Curves.easeOut,
//       scale: dimWhenAnimating ? 0.985 : 1,
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 220),
//         opacity: dimWhenAnimating ? 0.9 : 1,
//         child: Container(
//           width: 140.w,
//           height: 140.w,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: AppColors.primary, 
//               width: 2.w
//             ),
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 18,
//                 spreadRadius: 1,
//                 offset: Offset(0, 10),
//                 color: Colors.black12,
//               )
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Image.asset(asset, fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }

// class _OptionAvatar extends StatefulWidget {
//   final String asset;
//   final VoidCallback onTap;
//   final bool enabled;

//   const _OptionAvatar({
//     super.key,
//     required this.asset,
//     required this.onTap,
//     required this.enabled,
//   });

//   @override
//   State<_OptionAvatar> createState() => _OptionAvatarState();
// }

// class _OptionAvatarState extends State<_OptionAvatar> {
//   bool _pressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
//       onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
//       onTapUp: widget.enabled
//           ? (_) {
//               setState(() => _pressed = false);
//               widget.onTap();
//             }
//           : null,
//       child: AnimatedScale(
//         duration: const Duration(milliseconds: 120),
//         curve: Curves.easeOut,
//         scale: _pressed ? 0.94 : 1,
//         child: Container(
//           width: 70.w,
//           height: 70.w,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.black12, width: 1.5),
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Image.asset(widget.asset, fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }

// class _FlyingAvatar extends StatelessWidget {
//   final String asset;

//   const _FlyingAvatar({required this.asset});

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 1.04,
//       child: Container(
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 22,
//               spreadRadius: 2,
//               offset: Offset(0, 14),
//               color: Color(0x33000000),
//             )
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Image.asset(asset, fit: BoxFit.cover),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarPickerFlySwap extends StatefulWidget {
  final List<String> assetPaths;

  /// Chamado ao clicar na câmera.
  /// Você faz o fluxo fora do widget e retorna o path da foto (ou null se cancelou).
  final Future<String?> Function()? onTakePhoto;

  /// Retorna o "path" selecionado:
  /// - se for avatar padrão: assetPath
  /// - se for foto: filePath
  final ValueChanged<String>? onSelected;

  const AvatarPickerFlySwap({
    super.key,
    required this.assetPaths,
    this.onTakePhoto,
    this.onSelected,
  });

  @override
  State<AvatarPickerFlySwap> createState() => _AvatarPickerFlySwapState();
}

class _AvatarPickerFlySwapState extends State<AvatarPickerFlySwap>
    with SingleTickerProviderStateMixin {
  late List<String> _avatars; // apenas assets (sempre)
  String? _photoPath; // foto no centro (se existir)

  final _centerKey = GlobalKey();
  late final List<GlobalKey> _slotKeys;

  late final AnimationController _controller;

  OverlayEntry? _overlay;
  int? _hiddenSlotIndex;
  bool _animating = false;

  Rect? _startRect;
  Rect? _endRect;
  String? _flyingAsset;

  bool get _hasPhoto => _photoPath != null;

  @override
  void initState() {
    super.initState();
    _avatars = List.of(widget.assetPaths);
    _slotKeys = List.generate(_avatars.length, (_) => GlobalKey());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // seleção inicial = avatar do centro
    if (_avatars.isNotEmpty) {
      widget.onSelected?.call(_avatars[0]);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlay?.remove();
    super.dispose();
  }

  Rect _rectFromKey(GlobalKey key) {
    final box = key.currentContext!.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero);
    return topLeft & box.size;
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  Future<void> _flySwapToCenter(int slotIndex) async {
    if (_animating) return;
    if (slotIndex == 0) return;

    // ✅ enquanto tem foto, não deixa trocar pelos avatares
    if (_hasPhoto) return;

    setState(() => _animating = true);

    _removeOverlay();

    _flyingAsset = _avatars[slotIndex];

    _startRect = _rectFromKey(_slotKeys[slotIndex]);
    _endRect = _rectFromKey(_centerKey);

    setState(() => _hiddenSlotIndex = slotIndex);

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _overlay = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: curve,
          builder: (_, __) {
            final t = curve.value;
            final r = Rect.lerp(_startRect!, _endRect!, t)!;

            return Positioned(
              left: r.left,
              top: r.top,
              width: r.width,
              height: r.height,
              child: IgnorePointer(
                child: _FlyingAvatar(asset: _flyingAsset!),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);

    _controller.reset();
    await _controller.forward();

    setState(() {
      final tmp = _avatars[0];
      _avatars[0] = _avatars[slotIndex];
      _avatars[slotIndex] = tmp;

      _hiddenSlotIndex = null;
      _animating = false;
    });

    widget.onSelected?.call(_avatars[0]);

    _removeOverlay();
  }

  Future<void> _onCameraTap() async {
    if (_animating) return;
    if (widget.onTakePhoto == null) return;

    final path = await widget.onTakePhoto!.call();
    if (!mounted) return;
    if (path == null || path.isEmpty) return;

    setState(() {
      if (_hasPhoto) {
        // se já tem foto, só substitui
        _photoPath = path;
      } else {
        // regra: pega avatar do centro e joga pro último
        if (_avatars.isNotEmpty) {
          final oldCenter = _avatars.removeAt(0);
          _avatars.add(oldCenter);
        }
        _photoPath = path;
      }
    });

    widget.onSelected?.call(path);
  }

  void _clearPhoto() {
    if (_animating) return;
    if (!_hasPhoto) return;

    setState(() {
      _photoPath = null;

      // regra: último avatar volta pro centro
      if (_avatars.isNotEmpty) {
        final last = _avatars.removeLast();
        _avatars.insert(0, last);
      }
    });

    widget.onSelected?.call(_avatars[0]);
  }

  @override
  Widget build(BuildContext context) {
    // centro: foto ou avatar
    final centerAsset = _avatars.isNotEmpty ? _avatars[0] : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CenterAvatar(
          key: _centerKey,
          asset: centerAsset,
          photoPath: _photoPath,
          dimWhenAnimating: _animating,
          onCameraTap: _onCameraTap,
          onClearPhoto: _clearPhoto,
        ),
        25.verticalSpaceFromWidth,
        Wrap(
          spacing: 15.w,
          runSpacing: 15.w,
          alignment: WrapAlignment.center,
          children: List.generate(_avatars.length - 1, (i) {
            final slotIndex = i + 1;
            final isHidden = _hiddenSlotIndex == slotIndex;

            return Opacity(
              opacity: isHidden ? 0 : 1,
              child: _OptionAvatar(
                key: _slotKeys[slotIndex],
                asset: _avatars[slotIndex],
                enabled: !_animating && !_hasPhoto, // ✅ trava quando tem foto
                onTap: () => _flySwapToCenter(slotIndex),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CenterAvatar extends StatelessWidget {
  final String? asset;
  final String? photoPath;
  final bool dimWhenAnimating;

  final VoidCallback onCameraTap;
  final VoidCallback onClearPhoto;

  const _CenterAvatar({
    super.key,
    required this.asset,
    required this.photoPath,
    required this.dimWhenAnimating,
    required this.onCameraTap,
    required this.onClearPhoto,
  });

  bool get _hasPhoto => photoPath != null;


  @override
  Widget build(BuildContext context) {
    final borderW = 2.w;

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      scale: dimWhenAnimating ? 0.985 : 1,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: dimWhenAnimating ? 0.9 : 1,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: borderW),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: Offset(0, 10),
                    color: Colors.black12,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(borderW), 
                child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer, 
                  child: _hasPhoto
                      ? Image.file(File(photoPath!), fit: BoxFit.cover)
                      : Image.asset(asset!, fit: BoxFit.cover),
                ),
              ),
            ),

            // ✅ Botão câmera (sempre)
            Positioned(
              right: -2.w,
              bottom: -2.w,
              child: _CircleIconButton(
                icon: Icons.photo_camera_rounded,
                onTap: onCameraTap,
              ),
            ),

            // ✅ Botão limpar (só quando tem foto)
            if (_hasPhoto)
              Positioned(
                left: -2.w,
                bottom: -2.w,
                child: _CircleIconButton(
                  icon: Icons.close_rounded,
                  onTap: onClearPhoto,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _OptionAvatar extends StatefulWidget {
  final String asset;
  final VoidCallback onTap;
  final bool enabled;

  const _OptionAvatar({
    super.key,
    required this.asset,
    required this.onTap,
    required this.enabled,
  });

  @override
  State<_OptionAvatar> createState() => _OptionAvatarState();
}

class _OptionAvatarState extends State<_OptionAvatar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        scale: _pressed ? 0.94 : 1,
        child: Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(widget.asset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _FlyingAvatar extends StatelessWidget {
  final String asset;

  const _FlyingAvatar({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.04,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 22,
              spreadRadius: 2,
              offset: Offset(0, 14),
              color: Color(0x33000000),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}