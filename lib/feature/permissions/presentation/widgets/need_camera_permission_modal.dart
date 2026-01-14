// Mostra um dialog de erro.
import 'dart:ui';

import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

/// [message] pode ser customizada.
Future<void> showCameraPermissionDialog(
  BuildContext context, {
  required VoidCallback function
}) async {

  await precacheImage(
    const AssetImage(AppAssets.camersPermissionIos),
    context,
  );

  if (!context.mounted) return;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // pode fechar ao tocar fora
    barrierColor: Colors.black.withAlpha(51), // fundo ofuscado
    builder: (dialogContext) {
      return Dialog(
        elevation: 15,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightDisabelButton,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  20.w,
                  24.w,
                  20.w
                ),
                child: Column(
                  children: [
                    Text(
                      "Permitir o uso da câmera",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkTextColor
                      ),
                    ),
                    10.verticalSpaceFromWidth,
                    Text(
                      "Para registrar vídeos e fotos importantes da sua bagagem, permita que o Bagaer acesse a câmera nas configurações do dispositivo.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkTextColor
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                24.w,
                20.w,
                24.w,
                0.w
              ),
              child: SizedBox(
                width: 300.w,
                height: 200.w,
                child: Image.asset(
                  AppAssets.camersPermissionIos,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                  // width: 200.w,
                ),
              ),
            ),
            5.verticalSpaceFromWidth,
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightDisabelButton,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r))
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 65.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                      }, 
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor: WidgetStatePropertyAll(AppColors.primary),
                        elevation: WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            // borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(5.r)),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 0.5.w,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "Não autorizar"
                      )
                    ),
                  ),
                  // Divider(
                  //   color: AppColors.primary,
                  //   height: 0,
                  //   thickness: 1.w,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: 65.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        await openAppSettings();
                      }, 
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor: WidgetStatePropertyAll(AppColors.primary),
                        elevation: WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.vertical(bottom: Radius.circular(15.r)),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 0.5.w,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "Abrir as configurações"
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}