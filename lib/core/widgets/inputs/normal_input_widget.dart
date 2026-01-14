import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode node;
  final String hint;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  const NormalInputWidget({super.key, required this.controller, required this.node, required this.hint, this.inputType = TextInputType.text, this.capitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      height: 56.w,
      child: TextField(
        focusNode: node,
        controller: controller,
        keyboardType: inputType,
        textCapitalization: capitalization,
        autocorrect: false,
        keyboardAppearance: Brightness.light,
        // onChanged: (value) {
        //   if (capitalization != TextCapitalization.words) return;

        //   final newValue = capitalizeWords(value);
        //   if (newValue == value) return;

        //   controller.value = controller.value.copyWith(
        //     text: newValue,
        //     selection: TextSelection.collapsed(offset: newValue.length),
        //     composing: TextRange.empty,
        //   );
        // },
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
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
        ),
        // onChanged: (value) => _checkFields(),
      ),
    );
  }
}

String capitalizeWords(String text) {
  return text
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');
}