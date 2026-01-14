import 'dart:ui';

import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum HeroLogoColor {
  blue,
  white,
}

extension HeroLogoColorExtension on HeroLogoColor {
  String get asset {
    switch (this) {
      case HeroLogoColor.blue:
        return AppAssets.logoHorizontalAzul;
      case HeroLogoColor.white:
        return AppAssets.logoHorizontalClaro;
    }
  }
}

class BagaerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? titleColor;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final double height;
  final Color backgroundColor;
  final bool blurred;
  final bool centerTitle;
  final bool showHeroLogo;
  final HeroLogoColor heroLogoColor;
  final Widget? leading;

  const BagaerAppBar({
    super.key,
    this.title,
    this.titleColor = AppColors.darkTextColor,
    this.titleWidget,
    this.showBackButton = true,
    this.showHeroLogo = true,
    this.heroLogoColor = HeroLogoColor.blue,
    this.onBack,
    this.actions,
    this.height = kToolbarHeight,
    this.backgroundColor = Colors.transparent,
    this.blurred = false,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final content = AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? leading ?? IconButton(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: SizedBox(
                width: 20.w,
                height: 20.w,
                child: SvgPicture.asset(
                  AppAssets.backButton
                ),
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: (showHeroLogo && title == null) 
      ? Hero(
          tag: 'bagaer-logo',
          child: SizedBox(
            width: 150.r,
            height: 44.r,
            child: Image.asset(
              heroLogoColor.asset,
              fit: BoxFit.contain,
            ),
          )
        )
      : titleWidget 
        ?? (title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: titleColor
                ),
              )
            : null
           ),
      actions: actions,
    );

    if (!blurred) return content;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      ),
    );
  }
}