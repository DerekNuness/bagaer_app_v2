import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ChipWidget extends StatelessWidget {
  final String string;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;
  final Color unselectedBackgroundColor;
  final Color selectedBackgroundColor;
  final Color textColor;
  final double? horizontalPadding;
  final VoidCallback onTap;
  final bool isSelected;
  const ChipWidget({
    super.key, 
    required this.string, 
    required this.onTap,
    required this.isSelected,
    this.selectedBorderColor = Colors.black, 
    this.unselectedBorderColor = Colors.black, 
    this.selectedBackgroundColor = Colors.white, 
    this.unselectedBackgroundColor = Colors.white, 
    this.textColor = Colors.black, 
    this.horizontalPadding
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 31.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29.r),
          color: isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: isSelected ? 2.w : 1.w,
            strokeAlign: BorderSide.strokeAlignOutside
          )
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
          child: Text(
            string,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}

class ChipShimmerWidget extends StatelessWidget {
  final double? width;

  const ChipShimmerWidget({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: Container(
        height: 31.w,
        width: width ?? 80.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29.r),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}

