import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.lightBackground,

      primaryColor: AppColors.primary,

      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.lightBlue,
        surface: AppColors.lightBackground,
      ),

      textTheme: TextTheme(
        bodySmall: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextColor,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputColor,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400
        ),
        prefixIconColor: AppColors.lightBlue,
        suffixIconColor: AppColors.lightBlue,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:  BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:  BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightBlue,
          minimumSize: Size.fromHeight(53.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightBackground,
          minimumSize: Size.fromHeight(53.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          side: BorderSide(
            color: AppColors.lightBlue,
            width: 3.w
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightBackground,
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }

  // static ThemeData get dark {
  //   return ThemeData(
  //     useMaterial3: false,
  //     scaffoldBackgroundColor: AppColors.surfaceMuted,

  //     primaryColor: AppColors.primary,

  //     colorScheme: ColorScheme.light(
  //       primary: AppColors.primary,
  //       secondary: AppColors.primaryLight,
  //       surface: AppColors.surface,
  //       background: AppColors.surfaceMuted,
  //     ),

  //     textTheme: TextTheme(
  //       bodyMedium: AppTextStyles.input,
  //       labelLarge: AppTextStyles.button,
  //     ),

  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: AppColors.surface,
  //       hintStyle: AppTextStyles.hint,
  //       prefixIconColor: AppColors.icon,
  //       suffixIconColor: AppColors.icon,

  //       contentPadding:
  //           const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide:
  //             const BorderSide(color: AppColors.primary, width: 1.5),
  //       ),
  //     ),

  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primary,
  //         minimumSize: const Size.fromHeight(56),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         textStyle: AppTextStyles.button,
  //       ),
  //     ),

  //     cardTheme: CardThemeData(
  //       color: AppColors.surface,
  //       elevation: 6,
  //       shadowColor: Colors.black12,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(24),
  //       ),
  //     ),
  //   );
  // }
}