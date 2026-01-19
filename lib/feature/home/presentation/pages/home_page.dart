import 'dart:ui';

import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/feature/auth/domain/entities/auth_session.dart';
import 'package:bagaer/feature/auth/domain/entities/user_entity.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthSession session;
  late UserEntity user;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      session = authState.session;
      user = session.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topRight,
            //       end: Alignment.bottomLeft,
            //       colors: [
            //         AppColors.gradientOne,
            //         AppColors.gradientTwo,
            //         AppColors.gradientTwo,
            //         AppColors.gradientThree,
            //         AppColors.gradientFour,
            //         AppColors.gradientFive,
            //       ],
            //     ),
            //     borderRadius: BorderRadius.vertical(
            //       bottom: Radius.circular(22.r),
            //     ),
            //   ),
            //   height: 260.w
            // ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22.r),
                ),
              ),
              height: 280.w
            ),
            // Column(
            //   children: [
            //     148.verticalSpaceFromWidth,
            //     Expanded(
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: AppColors.homeBackgroundColor,
            //           borderRadius: BorderRadius.vertical(top: Radius.circular(22.r))
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Column(
            //   children: [
            //     BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: AppColors.homeBackgroundColor.withAlpha(1),
            //           borderRadius: BorderRadius.vertical(
            //             bottom: Radius.circular(22.r),
            //           ),
            //         ),
            //         height: 260.w
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 20.w),
              child: Column(
                children: [
                  30.verticalSpaceFromWidth,
                  SizedBox(
                    width: 150.r,
                    height: 44.r,
                    child: Image.asset(
                      LogoColor.white.asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  25.verticalSpaceFromWidth,
                  Row(
                    children: [
                      /// Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.lightBackground, width: 2.w),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: ClipOval(
                          clipBehavior: Clip.antiAliasWithSaveLayer, 
                          child: CachedNetworkImage(
                            imageUrl: user.profilePicture,
                            width: 60.w,
                            height: 60.w,
                          )
                        ),
                      ),
                      /// Welcome Message
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Bem vindo\n",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.white
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold
                                      )
                                    )
                                  ]
                                )
                              )
                            ],
                          ),
                        )
                      ),
                      /// Notification icon
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: AppColors.white,
                              width: 2.w
                            ),
                            shape: BoxShape.circle
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: SvgPicture.asset(
                              AppAssets.notificationIcon,
                              width: 25.sp,
                              height: 25.sp,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  60.verticalSpaceFromWidth,
                  /// Dashboard row
                  Container(
                    height: 55.w,
                    width: 330.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(7.r))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.luggage_outlined,
                                size: 24.sp,
                              ),
                              Text(
                                "Incompletas",
                                style: TextStyle(
                                  fontSize: 11.sp, 
                                  color: AppColors.darkTextColor,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          )
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_airport_outlined,
                                size: 24.sp,
                              ),
                              Text(
                                "A Despachar",
                                style: TextStyle(
                                  fontSize: 11.sp, 
                                  color: AppColors.darkTextColor,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          )
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 24.sp,
                              ),
                              Text(
                                "A Pagar",
                                style: TextStyle(
                                  fontSize: 11.sp, 
                                  color: AppColors.darkTextColor,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          )
                        ),
                      ],
                    ),
                  )
                  /// CTA button
                  /// Discount banner
                  /// CTA to adds
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}