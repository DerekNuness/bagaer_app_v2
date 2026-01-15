import 'dart:io';

import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/crop_image/crop_image.dart';
import 'package:bagaer/core/widgets/overlays/top_notifications_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/widgets/avatar_switcher.dart';
import 'package:bagaer/feature/media/domain/entities/media_kind.dart';
import 'package:bagaer/feature/media/presentation/bloc/media_capture_bloc/media_capture_bloc.dart';
import 'package:bagaer/feature/permissions/presentation/widgets/need_camera_permission_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterUploadPhotoPage extends StatefulWidget {
  const RegisterUploadPhotoPage({super.key});

  @override
  State<RegisterUploadPhotoPage> createState() =>
      _RegisterUploadPhotoPageState();
}

class _RegisterUploadPhotoPageState extends State<RegisterUploadPhotoPage> {
  String profileImg = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MediaCaptureBloc, MediaCaptureState>(
          listener: (context, state) {
            if (state is NoCameraPermission) {
              // showTopNotification(
              //   context,
              //   title: "Erro",
              //   message: "Permissão negada",
              //   backgroundColor: AppColors.errorRed
              // );
              showCameraPermissionDialog(context, function: () {});
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            final status = state.status;

            if (status == RegisterStatus.failure) {
              showTopNotification(context,
                title: "Erro",
                message: state.failure!.message,
                backgroundColor: AppColors.errorRed
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 21.w),
          child: Column(
            children: [
              5.verticalSpaceFromWidth,
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Personalize seu perfil",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              38.verticalSpaceFromWidth,
              SizedBox(
                width: 348.w,
                child: Text(
                  "Tire uma foto ou escolha um avatar, você poderá editar quando quiser na página de edição de perfil ",
                  style: TextStyle(
                    color: AppColors.darkTextColor,
                    fontSize: 16.sp,
                    height: 1.15.w
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              50.verticalSpaceFromWidth,
              AvatarPickerFlySwap(
                assetPaths: const [
                  AppAssets.profileAvatarMasculino1,
                  AppAssets.profileAvatarMasculino2,
                  AppAssets.profileAvatarMasculino3,
                  AppAssets.profileAvatarMasculino4,
                  AppAssets.profileAvatarFeminino1,
                  AppAssets.profileAvatarFeminino2,
                  AppAssets.profileAvatarFeminino3,
                  AppAssets.profileAvatarFeminino4,
                  AppAssets.profileAvatarFeminino5,
                ],
                onTakePhoto: () async {
                  final bloc = context.read<MediaCaptureBloc>();

                  final responseFuture = bloc.stream.firstWhere(
                    (s) => s is MediaReady || s is MediaCaptureError,
                  );

                  bloc.add(CaptureMediaRequested(MediaKind.photo, false));

                  try {
                    final state = await responseFuture;

                    if (state is MediaReady) {
                      final path = state.media.originalPath;

                      if (!context.mounted) return null; 
                      
                      final croppedPath = await cropSquare(path);
                      return croppedPath;
                    }
                  } catch (e) {
                    debugPrint("Erro ou cancelamento na captura: $e");
                  }

                  return null;
                },
                onSelected: (value) {
                  profileImg = value;
                  debugPrint("Path: $profileImg");
                },
              ),
              120.verticalSpaceFromWidth,
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state.status == RegisterStatus.loading) {
                    return Center(
                      child: SizedBox(
                        height: 51.w,
                        width: 51.w,
                        child: CircularProgressIndicator(
                          color: AppColors.lightBlue,
                          backgroundColor:
                              AppColors.lightDisabelButtonText,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: 333.w,
                    height: 51.w,
                    child: ElevatedButton(
                      onPressed: profileImg.isEmpty
                      ? null
                      : () { 
                        // final isAsset = profileImg.startsWith('assets/');

                        // if (!isAsset) {
                        //   final imgFile = File.fromRawPath(profileImg)
                        //   context.read<RegisterBloc>().add(RegisterUploadProfilePictureRequested(imgFile.path));
                        // } else {
                        //   // ✅ envia arquivo real
                        //   context.read<RegisterBloc>().add(RegisterUploadProfilePictureRequested(profileImg));
                        // }
                        context.read<RegisterBloc>().add(RegisterUploadProfilePictureRequested(profileImg));
                      },
                      child: Text(
                        "Salvar imagem",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                  );
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
