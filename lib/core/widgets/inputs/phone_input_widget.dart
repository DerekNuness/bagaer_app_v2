import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:bagaer/core/widgets/country/country_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneInputWidget extends StatelessWidget {
  final TextEditingController textController; 
  final FocusNode focusNode; 
  final CountryDocument initialCountry;
  final bool autoFocus;
  final ValueChanged<CountryDocument> onSelect;
  
  const PhoneInputWidget({
    super.key, 
    required this.textController, 
    required this.focusNode, 
    required this.initialCountry, 
    required this.onSelect,
    this.autoFocus = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              left: BorderSide(
                width: 1.w,
                color: AppColors.primary
              ),
              top: BorderSide(
                width: 1.w,
                color: AppColors.primary
              ),
              bottom: BorderSide(
                width: 1.w,
                color: AppColors.primary
              ),
              right: BorderSide.none  
            ),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r), right: Radius.zero),
          ),
          width: 128.w,
          height: 56.w,
          child: CountrySelect(
            mode: CountrySelectMode.dialCode,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r), right: Radius.zero),
              color: AppColors.lightInputColor
            ),
            dropdownWidth: 350.w,
            dropdownHeight: 277.w,
            initialCountry: initialCountry,
            onSelect: onSelect,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 56.w,
            child: TextField(
              focusNode: focusNode,
              autofocus: autoFocus,
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkTextColor,
              ),
              decoration: InputDecoration(
                hintText: '(11) 23456-7890',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(8.r), left: Radius.zero),
                  borderSide:  BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(8.r), left: Radius.zero),
                  borderSide:  BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(8.r), left: Radius.zero),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              // onChanged: (value) => _checkFields(),
            ),
          ),
        ),
      ],
    );
  }
}