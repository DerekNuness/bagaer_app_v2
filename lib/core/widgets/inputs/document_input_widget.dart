import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:bagaer/core/widgets/country/country_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentInputWidget extends StatelessWidget {
  final TextEditingController textController; 
  final FocusNode focusNode; 
  final CountryDocument initialCountry;
  final bool autoFocus;
  final ValueChanged<CountryDocument> onSelect;
  const DocumentInputWidget({super.key, required this.textController, required this.focusNode, required this.initialCountry, this.autoFocus = false, required this.onSelect, });

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
            mode: CountrySelectMode.document,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r), right: Radius.zero),
              color: AppColors.lightInputColor
            ),
            dropdownWidth: 330.w,
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
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkTextColor,
              ),
              decoration: InputDecoration(
                hintText: '000.000.000-00',
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
    );;
  }
}