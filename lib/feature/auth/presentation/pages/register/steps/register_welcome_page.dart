import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/navigation/main_scaffold.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterWelcomePage extends StatelessWidget {
  const RegisterWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.verticalSpaceFromWidth,
                // Texto de boas-vindas com o nome do usuário
                Padding(
                  padding: EdgeInsets.only(left: 21.w),
                  child: RichText(
                    // textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                      ),
                      children: [
                        const TextSpan(text: "Pronto, "),
                        TextSpan(
                          text: (state.session != null) ? state.session!.user.name : 'Usuário',
                          style: TextStyle(color: AppColors.lightBlue)),
                        const TextSpan(text: "\nBem-vindo ao Bagaer!"),
                      ],
                    ),
                  ),
                ),
                30.verticalSpaceFromWidth,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: RichText(
                    // textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        // height: 23.h
                      ),
                      children: [
                        const TextSpan(text: "Para começar, você já tem "),
                        TextSpan(
                          text: "50% Off ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        const TextSpan(text: "no registro e autenticação de bagagens em seus próximos despachos, sem medo!"),
                      ],
                    ),
                  ),
                ),
                20.verticalSpaceFromWidth,
                // Imagem central de boas-vindas
                SizedBox(
                  width: 350.w,
                  height: 350.w,
                  child: Image.asset(
                    'assets/images/welcome_img.jpg',
                    // 'assets/images/welcome.png',
                    fit: BoxFit.fill,
                  ),
                ),
                // Botão para adicionar foto de perfil
                // const Spacer(),
                60.verticalSpaceFromWidth,
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 330.w,
                    height: 51.w,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthSessionChanged(state.session!));
                        sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
                          context,
                          const MainScaffold(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'Ir para a home',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
