import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/core/widgets/inputs/password_input_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RegisterCreateUserPage extends StatefulWidget {
  const RegisterCreateUserPage({super.key});

  @override
  State<RegisterCreateUserPage> createState() => _RegisterCreateUserPageState();
}

class _RegisterCreateUserPageState extends State<RegisterCreateUserPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();

  //Obscure text
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  // Validador
  bool _isFormValid = false;

  // Password strengh
  double _passwordStrength = 0.0;
  Color _strengthColor = Colors.red;

  void _validateForm() {
    final password = _passwordController.text.trim();
    final confirmationPassword = _passwordConfirmationController.text.trim();

    _calculatePasswordStrength(password);

    final passwordIsValid = password.length >= 8;
    final confirmationValid = confirmationPassword.isNotEmpty;

    final isValid =
        passwordIsValid &&
        confirmationValid &&
        password == confirmationPassword;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _strengthColor = AppColors.redPasswordStrength;
      });
      return;
    }

    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasSpecialChar =
        password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    int fulfilledRules = 0;
    if (hasMinLength) fulfilledRules++;
    if (hasUppercase) fulfilledRules++;
    if (hasLowercase) fulfilledRules++;
    if (hasSpecialChar) fulfilledRules++;

    double normalized = fulfilledRules / 4;

    // ✅ Qualquer coisa digitada já mostra "fraca"
    if (password.isNotEmpty && normalized == 0) {
      normalized = 0.25;
    }

    Color color;
    if (normalized <= 0.25) {
      color = AppColors.redPasswordStrength;
    } else if (normalized <= 0.5) {
      color = AppColors.orangePasswordStrength;
    } else if (normalized <= 0.75) {
      color = AppColors.bluePasswordStrength;
    } else {
      color = AppColors.greenPasswordStrength;
    }

    setState(() {
      _passwordStrength = normalized;
      _strengthColor = color;
    });
  }

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(_validateForm);
    _passwordConfirmationController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationController.dispose();
    _passwordConfirmationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        context.read<RegisterBloc>().add(RegisterBackToPhone());
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: BagaerAppBar(
            titleWidget: Hero(
              tag: 'bagaer-logo',
              child: SizedBox(
                width: 150.r,
                height: 44.r,
                child: Image.asset(
                  LogoColor.blue.asset,
                  fit: BoxFit.contain,
                ),
              )
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(21.w, 40.h, 21.w, 15.h),
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔼 TOPO
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Crie sua senha:",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                            30.verticalSpaceFromWidth,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: 'Digite sua senha ',
                                    style: TextStyle(
                                      fontSize: 16.sp, 
                                      color: AppColors.darkTextColor,
                                      fontWeight: FontWeight.w500
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '(obrigatório)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.darkTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpaceFromWidth,
                                PasswordInputWidget(
                                  textController: _passwordController, 
                                  focusNode: _passwordFocusNode, 
                                  obscureText: _obscurePassword, 
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  }
                                ),
                                if (_passwordStrength > 0) ...[
                                  Column(
                                    children: [
                                      10.verticalSpaceFromWidth,
                                      Text(
                                        _passwordStrength <= 0.25
                                                ? 'Senha fraca'
                                                : _passwordStrength <= 0.5
                                                    ? 'Senha média'
                                                    : _passwordStrength <= 0.75
                                                        ? 'Senha boa'
                                                        : 'Senha forte',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: _strengthColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      5.verticalSpaceFromWidth,
                                    ],
                                  ),
                                ] else ...[
                                  32.verticalSpaceFromWidth,
                                ],

                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: _passwordStrength,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                  builder: (context, value, _) {
                                    return Container(
                                      height: 10.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(100.r),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _strengthColor,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            20.verticalSpaceFromWidth,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: 'Repita sua senha ',
                                    style: TextStyle(
                                      fontSize: 16.sp, 
                                      color: AppColors.darkTextColor,
                                      fontWeight: FontWeight.w500
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '(obrigatório)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.darkTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpaceFromWidth,
                                PasswordInputWidget(
                                  textController: _passwordConfirmationController, 
                                  focusNode: _passwordConfirmationFocusNode, 
                                  obscureText: _obscurePasswordConfirmation, 
                                  onTap: () {
                                    setState(() {
                                      _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
                                    });
                                  }
                                ),
                              ],
                            ),
                            20.verticalSpaceFromWidth,
                            SizedBox(
                              width: 315,
                              child: Text(
                                "No mínimo 8 caracteres. Use letras maiúsculas, minúsculas, números e caracteres especiais.",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),

                            /// ⚠️ ERRO
                            if (state.status == RegisterStatus.failure && !keyboardOpen) ...[
                              Column(
                                children: [
                                  20.verticalSpaceFromWidth,
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/error_icon.svg',
                                            width: 15.w,
                                            height: 15.w,
                                            colorFilter: ColorFilter.mode(AppColors.errorRed, BlendMode.srcIn),
                                          ),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(maxWidth: 300.w),
                                            child: Text(
                                              state.failure!.message,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.errorRed,
                                                fontWeight: FontWeight.w400
                                              ),
                                              overflow: TextOverflow.clip
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ),
                                ],
                              ) 
                            ],
                          ],
                        ),
                        150.verticalSpaceFromWidth,
                        /// 🔽 BASE
                        Column(
                          children: [
                            20.verticalSpaceFromWidth,
                                
                            if (state.status == RegisterStatus.loading)
                              Center(
                                child: SizedBox(
                                  height: 53.h,
                                  width: 53.w,
                                  child: CircularProgressIndicator(
                                    color: AppColors.lightBlue,
                                    backgroundColor: AppColors.lightDisabelButtonText,
                                  ),
                                ),
                              )
                            else
                              ElevatedButton(
                                onPressed: _isFormValid
                                    ? () {
                                        FocusScope.of(context).unfocus();
                                
                                        context.read<RegisterBloc>().add(
                                          RegisterCreateUserRequested(
                                            phoneNumber: state.phoneNumber!, 
                                            password: _passwordController.text.trim(), 
                                            passwordConfirmation: _passwordConfirmationController.text.trim(), 
                                            newsletter: false, 
                                            notifications: true
                                          ),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  "Criar conta",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ),
      ),
    );
  }
}