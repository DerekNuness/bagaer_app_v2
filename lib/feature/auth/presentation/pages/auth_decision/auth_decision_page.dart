import 'dart:ui';

import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/localization/localization_extension.dart';
import 'package:bagaer/core/navigation/service/internal_navigator.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/feature/auth/presentation/pages/login/login_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/register_flow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthDecisionPage extends StatelessWidget {
  const AuthDecisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = InternalNavigator();
    
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Parte superior: fundo, ícone de ajuda e logo centralizada
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Imagem de fundo ocupando 75% da altura da tela
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.only(
                      bottomRight: Radius.circular(110.r)
                    ),
                    child: Image.asset(
                      'assets/images/auth_decision_background.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Botão de ajuda no canto superior direito
                  Positioned(
                    top: 40.h,
                    right: 20.w,
                    child: IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                  ),
                  Hero(
                    tag: 'bagaer-logo',
                    child: SizedBox(
                      width: 240.r,
                      child: Image.asset(
                        AppAssets.logoHorizontalClaro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Parte inferior: texto e botões "Entrar" e "Criar conta"
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 21.w,
                vertical: 35.h,
              ),
              child: Column(
                children: [
                  Text(
                    context.tr("auth_decision.title"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  33.verticalSpaceFromWidth,
                  SizedBox(
                    height: 53.h,
                    child: ElevatedButton(
                      onPressed: (){
                        nav.pushRightLeftAnimation(
                          context,
                          LoginPage()
                        );
                      }, 
                      child: Text(
                        context.tr("auth_decision.enter_button"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp
                        ),
                      )
                    ),
                  ),
                  
                  30.verticalSpaceFromWidth,
                  SizedBox(
                    height: 53.h,
                    child: OutlinedButton(
                      onPressed: () {
                        nav.pushRightLeftAnimation(
                          context,
                          RegisterFlowPage()
                        );
                        // sl<NavigationService>().pushRightLeftAnimation(
                        //   context, 
                        //   RegisterFlowPage()
                        // );
                      },
                      child: Text(
                        context.tr("auth_decision.register_button"),
                        style: TextStyle(
                          color: Color(0xFF4FB0FB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}