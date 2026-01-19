import 'dart:ui';
import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Mantenha seu Enum e Extension como estão
enum LogoColor {
  blue,
  white,
}

extension LogoColorExtension on LogoColor {
  String get asset {
    switch (this) {
      case LogoColor.blue:
        return AppAssets.logoHorizontalAzul; // Substitua pelos seus assets reais
      case LogoColor.white:
        return AppAssets.logoHorizontalClaro;
    }
  }
}

enum AppBarColor {
  blue,
  white,
  transparent
}

extension AppBarColorExtension on AppBarColor {
  Color get color {
    switch (this) {
      case AppBarColor.blue:
        return AppColors.primary; // Substitua pelos seus assets reais
      case AppBarColor.white:
        return AppColors.white;
      case AppBarColor.transparent:
        return AppColors.transparent;
    }
  }
}

class BagaerAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Opção 1: Texto simples
  final String? title;
  final Color titleColor; // Removi o '?' e deixei com default no construtor

  // Opção 2: Widget customizado
  final Widget? titleWidget;

  // Opção 3: Configuração da Logo (Default)
  final LogoColor logoColor;

  // Outras configurações
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final double height;
  final AppBarColor backgroundColor;
  final bool blurred;
  final bool centerTitle;
  final Widget? leading;

  const BagaerAppBar({
    super.key,
    this.title,
    this.titleColor = AppColors.darkTextColor, // Cor padrão se for texto
    this.titleWidget,
    this.logoColor = LogoColor.blue, // Cor padrão se for logo
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.height = kToolbarHeight,
    this.backgroundColor = AppBarColor.transparent,
    this.blurred = false,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  /// Método inteligente que decide o que mostrar
  Widget _buildTitleContent() {
    // 1. Prioridade Alta: Widget Customizado
    if (titleWidget != null) {
      return titleWidget!;
    }

    // 2. Prioridade Média: Texto Simples
    if (title != null) {
      return Text(
        title!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor,
          fontSize: 18.sp, // Adicionei um tamanho base, ajuste conforme seu design
        ),
      );
    }

    // 3. Prioridade Padrão: Logo (Fallback)
    return SizedBox(
      width: 150.r,
      height: 44.r,
      child: Image.asset(
        logoColor.asset,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final content = AppBar(
      backgroundColor: backgroundColor.color,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? leading ??
              IconButton(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: SvgPicture.asset(
                    AppAssets.backButton, // Certifique-se que esse asset existe
                  ),
                ),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
          : null,
      // A mágica acontece aqui: chamamos o método que decide o conteúdo
      title: _buildTitleContent(),
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