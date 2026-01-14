import 'dart:io';

import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/localization/localization_extension.dart';
import 'package:bagaer/core/navigation/main_scaffold.dart';
import 'package:bagaer/core/navigation/service/internal_navigator.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/core/widgets/inputs/password_input_widget.dart';
import 'package:bagaer/core/widgets/inputs/phone_input_widget.dart';
import 'package:bagaer/core/widgets/overlays/top_notifications_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/register_flow_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/register_flow_view.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_phone_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Navigator
  final nav = InternalNavigator();

  // Controllers
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  //Obscure text
  bool _obscurePassword = true;

  // Validador
  bool _isFormValid = false;

  void _validateForm() {
    final phone = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();

    final phoneIsValid = phone.isNotEmpty && RegExp(r'^\d+$').hasMatch(phone);
    final passwordIsValid = password.isNotEmpty;

    final isValid = phoneIsValid && passwordIsValid;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  late String _selectedPhoneDialCode;

  // PlatformInfo
  late PackageInfo packageInfo;
  late String platform;
  bool _platformReady = false;

  final brasil = CountryDocuments.documents.firstWhere(
    (c) => c.countryCode == 'BR',
  );

  @override
  void initState() {
    super.initState();
    _selectedPhoneDialCode = brasil.phoneDialCode;

    _phoneNumberController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);

    _getPlatformInfo();
  }

  Future<void> _getPlatformInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    platform = Platform.operatingSystem;

    setState(() {
      _platformReady = true;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // Erro no login
            if (state is LoginFailureState) {
              showTopNotification(
                context, 
                title: "Algo errado", 
                message: context.tr(state.failure.message), 
                backgroundColor: AppColors.errorRed
              );
            }
            // Login com sucesso
            if (state is LoginSuccess) {
              context.read<AuthBloc>().add(AuthSessionChanged(state.session));
              sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
                context,
                const MainScaffold(),
              );
            }
            // Cadastro incompleto
            if (state is LoginNeedsInfo) {
              final session = state.session;
              print("Enviando com o token: ${session.accessToken}");
              sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
                context,
                BlocProvider(
                  create: (context) => sl<RegisterBloc>()..add(SendToProfileDataStep(session: state.session)),
                  child: const RegisterFlowView(),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: BagaerAppBar(),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(21.w, 40.h, 21.w, 27.h),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr("login_page.title"),
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightBlue),
                            ),
                            13.verticalSpaceFromWidth,
                            Text(
                              context.tr("login_page.subtitle"),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkTextColor),
                            ),
                            40.verticalSpaceFromWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    context.tr("login_page.phone_label"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: AppColors.darkTextColor),
                                  ),
                                ),
                                11.verticalSpaceFromWidth,
                                PhoneInputWidget(
                                  textController: _phoneNumberController,
                                  focusNode: _phoneFocusNode,
                                  initialCountry: brasil,
                                  onSelect: (country) {
                                    setState(() {
                                      _selectedPhoneDialCode =
                                          country.phoneDialCode;
                                    });
                                  },
                                )
                              ],
                            ),
                            23.verticalSpaceFromWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    context.tr("login_page.password_label"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: AppColors.darkTextColor),
                                  ),
                                ),
                                11.verticalSpaceFromWidth,
                                PasswordInputWidget(
                                  textController: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: _obscurePassword,
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  context.tr("login_page.forgot_passord_label"),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkTextColor),
                                ),
                                SizedBox(
                                  // width: 80,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor:
                                          WidgetStateColor.transparent,
                                    ),
                                    onPressed: () {},
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        context.tr(
                                            "login_page.forgot_password_button"),
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.lightBlue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // BlocBuilder<LoginBloc, LoginState>(
                            //   builder: (context, state) {
                            //     if (state is LoginFailureState) {
                            //       final failure = state.failure;
                            //       return Column(
                            //         children: [
                            //           25.verticalSpaceFromWidth,
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               SvgPicture.asset(
                            //                 'assets/icons/error_icon.svg',
                            //                 width: 15.w,
                            //                 height: 15.w,
                            //                 colorFilter: ColorFilter.mode(
                            //                     AppColors.errorRed,
                            //                     BlendMode.srcIn),
                            //               ),
                            //               SizedBox(
                            //                 width: 10.w,
                            //               ),
                            //               Container(
                            //                 constraints:
                            //                     BoxConstraints(maxWidth: 300.w),
                            //                 child: Text(
                            //                     context.tr(failure.message),
                            //                     style: TextStyle(
                            //                         fontSize: 14.sp,
                            //                         color: AppColors.errorRed,
                            //                         fontWeight:
                            //                             FontWeight.w400),
                            //                     overflow: TextOverflow.clip),
                            //               )
                            //             ],
                            //           ),
                            //           80.verticalSpaceFromWidth,
                            //         ],
                            //       );
                            //     }
                            //     return 130.verticalSpaceFromWidth;
                            //   },
                            // ),
                            126.verticalSpaceFromWidth,
                            BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                              if (state is LoginLoading) {
                                return Center(
                                  child: SizedBox(
                                    height: 53.h,
                                    width: 53.w,
                                    child: CircularProgressIndicator(
                                      color: AppColors.lightBlue,
                                      backgroundColor:
                                          AppColors.lightDisabelButtonText,
                                    ),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: (_isFormValid && _platformReady)
                                    ? () {
                                        final fullPhone = '$_selectedPhoneDialCode${_phoneNumberController.text.trim()}';
                                        debugPrint('Login com: $fullPhone');
                                        context.read<LoginBloc>().add(
                                          LoginRequested(
                                            phoneNumber: fullPhone,
                                            password: _passwordController.text.trim(),
                                            appVersion: packageInfo.version,
                                            deviceOs: platform
                                          )
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFormValid
                                      ? AppColors.lightBlue
                                      : AppColors.lightDisabelButton,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Text(
                                  context.tr("login_page.enter_button"),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _isFormValid
                                        ? Colors.white
                                        : AppColors.lightDisabelButtonText,
                                  ),
                                ),
                              );
                            }),
                            30.verticalSpaceFromWidth,
                            Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      context.tr("login_page.call_to_register"),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.darkTextColor),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            WidgetStateColor.transparent,
                                      ),
                                      onPressed: () {
                                        nav.pushReplacementRightLeftAnimation(
                                            context, RegisterFlowPage());
                                      },
                                      child: Text(
                                        context.tr(
                                            "login_page.call_to_register_button"),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.lightBlue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
