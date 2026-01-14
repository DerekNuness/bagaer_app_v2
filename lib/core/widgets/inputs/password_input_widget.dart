import 'package:bagaer/core/localization/localization_extension.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PasswordInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode focusNode; 
  final bool obscureText;
  final VoidCallback onTap;

  const PasswordInputWidget({
    super.key, 
    required this.textController,
    required this.focusNode,
    required this.obscureText,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      height: 56.w,
      child: TextField(
        focusNode: focusNode,
        controller: textController,
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextColor,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^[\x00-\x7F]+$'),
          )
        ],
        decoration: InputDecoration(
          hintText: context.tr("login_page.password_hint"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
            borderSide:  BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
            borderSide:  BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          suffixIcon: AnimatedPasswordEye(
            obscure: obscureText,
            size: 28.r,
            color: AppColors.primary,
            onTap: onTap,
          ),
        ),
        // onChanged: (value) => _checkFields(),
      ),
    );
  }
}

class AnimatedPasswordEye extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  final double size;
  final Color color;

  const AnimatedPasswordEye({
    super.key,
    required this.obscure,
    required this.onTap,
    this.size = 22,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashRadius: size,
      icon: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/eye.svg',
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),

            // ➖ Barra animada
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.8,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: obscure
                ? SvgPicture.asset(
                    'assets/icons/eye_slash.svg',
                    key: const ValueKey('slash'),
                    width: size,
                    height: size,
                    colorFilter:
                        ColorFilter.mode(color, BlendMode.srcIn),
                  )
                : const SizedBox.shrink(
                    key: ValueKey('no_slash'),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}