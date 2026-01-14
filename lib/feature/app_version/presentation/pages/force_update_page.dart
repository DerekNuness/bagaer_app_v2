import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/feature/app_version/domain/entities/app_version_info.dart';
import 'package:bagaer/feature/app_version/presentation/widgets/release_notes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdatePage extends StatelessWidget {
  final AppVersionInfo appConfig;
  const ForceUpdatePage({super.key, required this.appConfig});

  Future<void> _openStore() async {
    if (appConfig.url == null) return;

    final uri = Uri.parse(appConfig.url!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/horizon_logo.png',
                  width: 200.w,
                ),
                SizedBox(height: 50.h),
            
                Text(
                  "Olá, passageiro! ✈️",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkTextColor
                  ),
                ),
            
                SizedBox(height: 20.h),
            
                Text(
                  "Uma nova versão do aplicativo está disponível.",
                  style: TextStyle(
                    fontSize: 20.sp, 
                    height: 1.4.h,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkTextColor
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
            
                Text(
                  "Atualize agora para continuar utilizando todos os recursos "
                  "e ficar por dentro das novidades.",
                  style: TextStyle(
                    fontSize: 18.sp, 
                    height: 1.4.h,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkTextColor
                  ),
                  textAlign: TextAlign.center,
                ),
            
                SizedBox(height: 100.h),
                // const Spacer(),
            
                Text(
                  "Novidades da versão ${appConfig.version}:",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                SizedBox(height: 10.h),
            
                ReleaseNotesFlyout(
                  version: appConfig.version,
                  releaseNotes: appConfig.releaseNotes,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.cardGrey,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.lightGreyText),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        appConfig.releaseNotes,
                        style: TextStyle(
                          fontSize: 16.sp,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
            
                const Spacer(),
            
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Atualizar agora",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}