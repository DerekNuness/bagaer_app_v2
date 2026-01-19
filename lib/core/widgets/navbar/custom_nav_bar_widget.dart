import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BagaerNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BagaerNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, // Ou Colors.red conforme seu teste
      elevation: 10,
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      
      child: SizedBox(
        height: 70.w,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildNavItem("assets/icons/home_icon.svg", "HOME", 0, 24.sp, 24.sp)),
            Expanded(child: _buildNavItem("assets/icons/baggage_icon.svg", "BAGAGENS", 1, 24.sp, 24.sp)),
            
            Expanded(child: SizedBox()), // Espaço do botão central
        
            Expanded(child: _buildNavItem("assets/icons/incidents_icon.svg", "OCORRENCIAS", 2, 24.sp, 24.sp)),
            Expanded(child: _buildNavItem("assets/icons/profile_icon.svg", "PERFIL", 3, 24.sp, 24.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index, double width, double height) {
    bool isSelected = currentIndex == index;
    // Ajuste as cores conforme seu AppColors
    Color color = isSelected ? AppColors.lightBlue : AppColors.darkTextColor; 

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: width,
            height: height,
          ),
          11.verticalSpaceFromWidth,
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}