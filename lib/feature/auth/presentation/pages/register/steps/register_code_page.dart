import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/core/widgets/timer/resend_code_timer.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RegisterCodePage extends StatefulWidget {
  final String phoneNumber;
  const RegisterCodePage({super.key, required this.phoneNumber});

  @override
  State<RegisterCodePage> createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  // Input
  String _code = '';

  // Button Validation
  bool _isFormValid = false;

  // App Signature
  String? appSignature;

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    _controller.forward();
    getAppSignature();
  }

  Future<void> getAppSignature() async {
    final signature = await SmsAutoFill().getAppSignature;
    if (mounted) {
      setState(() {
        appSignature = signature;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    SmsAutoFill().unregisterListener();
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
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.fromLTRB(21.w, 40.h, 21.w, 27.h),
            child: LayoutBuilder(builder: (context, constraints) {
              return BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Insira o código abaixo:",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkTextColor,
                                  ),
                                ),
                                25.verticalSpaceFromWidth,
                                SizedBox(
                                  width: 275.w,
                                  child: Text(
                                    "Enviamos um SMS com o código de validação para o número informado.",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkTextColor,
                                    ),
                                  ),
                                ),
                                58.verticalSpaceFromWidth,
                                Padding(
                                  padding:EdgeInsets.symmetric(horizontal: 17.w),
                                  child: SizedBox(
                                    height: 66.w,
                                    child: PinFieldAutoFill(
                                      keyboardType: TextInputType.number,
                                      codeLength: 4,
                                      currentCode: _code,
                                      onCodeChanged: (code) {
                                        setState(() {
                                          _code = code ?? '';
                                        });
                                        if (_code.length > 3) {
                                          setState(() {
                                            _isFormValid = true;
                                          });
                                        } else {
                                          setState(() {
                                            _isFormValid = false;
                                          });
                                        }
                                      },
                                      onCodeSubmitted: (code) {},
                                      decoration: BoxLooseDecoration(
                                        gapSpace: 20.w,
                                        bgColorBuilder: FixedColorBuilder(AppColors.lightInputColor),
                                        strokeColorBuilder: PinListenColorBuilder(AppColors.lightBlue, AppColors.lightBorderColor),
                                        radius: Radius.circular(15.r)
                                      )
                                    ),
                                  ),
                                ),
                                22.verticalSpaceFromWidth,
                                Center(
                                  child: ResendCodeTimer(
                                    initialSeconds: 60,
                                    onSecondsRemainigStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.lightResendCode
                                    ),
                                    textButtonStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary
                                    ),
                                    onResend: () {
                                      if (appSignature == null) return;

                                      context.read<RegisterBloc>().add(
                                          RegisterResendCodeRequested(
                                              phoneNumber: widget.phoneNumber,
                                              autoCompleteCode: appSignature!));
                                    },
                                  ),
                                ),
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
                                                width: 10.w,
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
                            Column(
                              children: [
                                if (state.status == RegisterStatus.loading)
                                  Center(
                                    child: SizedBox(
                                      height: 53.w,
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
                                        ? () async {
                                            FocusScope.of(context).unfocus();
                                            context.read<RegisterBloc>().add(
                                                RegisterVerifyCodeRequested(
                                                    phoneNumber:
                                                        widget.phoneNumber,
                                                    code: _code));
                                          }
                                        : null,
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15.h)),
                                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.disabled)) {
                                          return AppColors.lightDisabelButton;
                                        }
                                        return AppColors.lightBlue;
                                      }),
                                      foregroundColor:WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.disabled)) {
                                          return AppColors.lightDisabelButtonText;
                                        }
                                        return Colors.white;
                                      }),
                                      animationDuration: const Duration(milliseconds: 120),
                                    ),
                                    child: Text(
                                      "Verificar",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          )),
        ),
      ),
    );
  }
}
// textStyle: TextStyle(
//                                           fontSize: 22.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.darkTextColor,
//                                         ),
