import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/navigation/service/internal_navigator.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/core/widgets/inputs/phone_input_widget.dart';
import 'package:bagaer/core/widgets/text/bagaer_rich_text.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/login/login_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_code_page.dart';
import 'package:bagaer/feature/legal_info/presentation/pages/privacy_policy/privacy_policy_page.dart';
import 'package:bagaer/feature/legal_info/presentation/pages/terms_of_service/terms_of_service_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RegisterPhonePage extends StatefulWidget {
  const RegisterPhonePage({super.key});

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  //Navigator
  final nav = InternalNavigator();

  // Controllers
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  bool _isFormValid = false;
  String? _appSignature;
  late String _dialCode;

  final brasil = CountryDocuments.documents.firstWhere(
    (c) => c.countryCode == 'BR',
  );

  @override
  void initState() {
    super.initState();
    _dialCode = brasil.phoneDialCode;
    _phoneController.addListener(_validate);
    _loadAppSignature();
  }

  void _validate() {
    final phone = _phoneController.text.trim();
    final valid = phone.isNotEmpty && RegExp(r'^\d+$').hasMatch(phone);

    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  Future<void> _loadAppSignature() async {
    final sig = await SmsAutoFill().getAppSignature;
    if (mounted) setState(() => _appSignature = sig);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return FocusScope(
      node: FocusScopeNode(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false; 
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: const BagaerAppBar(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(21.w, 40.h, 21.w, 15.h),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔼 TOPO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 237.w,
                              child: BagaerRichText(
                                text: "Olá, vamos criar sua conta <blue>Bagaer</blue>",
                                highlightColor: AppColors.lightBlue,
                                textAlign: TextAlign.start,
                                baseStyle: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkTextColor,
                                ),
                              ),
                            ),
                            40.verticalSpaceFromWidth,
                            Text(
                              "Digite seu Celular ou Whatsapp",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                            11.verticalSpaceFromWidth,
                            PhoneInputWidget(
                              textController: _phoneController,
                              focusNode: _phoneFocus,
                              initialCountry: brasil,
                              onSelect: (c) => setState(() {
                                _dialCode = c.phoneDialCode;
                              }),
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
        
                        /// 🔽 BASE
                        Column(
                          children: [
                            _termsText(context),
                            20.verticalSpaceFromWidth,
        
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
                                onPressed: _isFormValid &&
                                        _appSignature != null
                                    ? () {
                                        FocusScope.of(context).unfocus();
        
                                        final fullPhone =
                                            '$_dialCode${_phoneController.text.trim()}';
        
                                        context.read<RegisterBloc>().add(
                                              RegisterSendCodeRequested(
                                                phoneNumber: fullPhone,
                                                autoCompleteCode: _appSignature!,
                                              ),
                                            );
                                      }
                                    : null,
                                child: Text(
                                  "Enviar código",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
        
                            20.verticalSpaceFromWidth,
                            _loginRedirect(context),
                          ],
                        ),
                      ],
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

  Widget _termsText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Ao continuar, você confirma que concorda com os ',
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        children: [
          TextSpan(
            text: 'Termos de Serviço',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lightBlue,
            ),
            recognizer: TapGestureRecognizer()
            ..onTap = () => sl<NavigationService>().pushRightLeftAnimation(
              context,
              const TermsOfServicePage(),
            ),
          ),
          const TextSpan(text: ' e '),
          TextSpan(
            text: 'Política de Privacidade',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lightBlue,
            ),
            recognizer: TapGestureRecognizer()
            ..onTap = () => sl<NavigationService>().pushRightLeftAnimation(
              context,
              const PrivacyPolicyPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Já possui conta?",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextColor
          )
        ),
        TextButton(
          onPressed: () => nav.pushReplacementRightLeftAnimation(context, const LoginPage(), rootNavigator: true),
          child: Text(
            "Faça login",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightBlue
            ),
          ),
        ),
      ],
    );
  }
}