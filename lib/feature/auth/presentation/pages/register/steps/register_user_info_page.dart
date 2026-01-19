import 'dart:io';

import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/core/widgets/country/country_select_widget.dart';
import 'package:bagaer/core/widgets/inputs/document_input_widget.dart';
import 'package:bagaer/core/widgets/inputs/normal_input_widget.dart';
import 'package:bagaer/core/widgets/overlays/top_notifications_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RegisterUserInfoPage extends StatefulWidget {
  const RegisterUserInfoPage({super.key});

  @override
  State<RegisterUserInfoPage> createState() => _RegisterUserInfoPageState();
}

class _RegisterUserInfoPageState extends State<RegisterUserInfoPage> {
  ///Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _documentNode = FocusNode();

  // Pre selected country
  CountryDocument _selectedCountry = CountryDocuments.documents.firstWhere(
    (c) => c.countryCode == 'BR',
  );

  CountryDocument _selectedDocument = CountryDocuments.documents.firstWhere(
    (c) => c.countryCode == 'BR',
  );

  bool _isFormValid = false;

  // Package and Device info
  late PackageInfo packageInfo;
  late String platform;
  bool _platformReady = false;

  Future<void> _getPlatformInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    platform = Platform.operatingSystem;

    setState(() {
      _platformReady = true;
    });
  }

  void _validateForm() {
    final name = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final document = _documentController.text.trim();

    // Regex
    final nameRegex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$');
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );
    final documentRegex = RegExp(r'^[A-Za-z0-9]+$');

    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F6FF}'
      r'\u{1F700}-\u{1F77F}'
      r'\u{1F780}-\u{1F7FF}'
      r'\u{1F800}-\u{1F8FF}'
      r'\u{1F900}-\u{1F9FF}'
      r'\u{1FA00}-\u{1FAFF}'
      r'\u{2600}-\u{26FF}'
      r'\u{2700}-\u{27BF}]',
      unicode: true,
    );

    final nameIsValid = name.isNotEmpty &&
        nameRegex.hasMatch(name) &&
        !emojiRegex.hasMatch(name);

    final lastNameIsValid = lastName.isNotEmpty &&
        nameRegex.hasMatch(lastName) &&
        !emojiRegex.hasMatch(lastName);

    final emailIsValid = email.isNotEmpty &&
        emailRegex.hasMatch(email) &&
        !emojiRegex.hasMatch(email);

    final documentIsValid = document.isNotEmpty &&
        documentRegex.hasMatch(document) &&
        !emojiRegex.hasMatch(document);

    final isValid =
        nameIsValid && lastNameIsValid && emailIsValid && documentIsValid;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _documentController.addListener(_validateForm);

    _getPlatformInfo();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
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
      child: FocusScope(
        node: FocusScopeNode(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: BagaerAppBar(
                showBackButton: false,
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
              body: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return SafeArea(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(21.w, 10.w, 21.w, 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.verticalSpaceFromWidth,
                          Text(
                            "Preencha suas informações:",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          20.verticalSpaceFromWidth,

                          /// Country
                          Text(
                            "Qual seu país de residência?",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.darkTextColor),
                          ),
                          11.verticalSpaceFromWidth,
                          Container(
                            width: 333.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                left: BorderSide(
                                    width: 1.w, color: AppColors.primary),
                                top: BorderSide(
                                    width: 1.w, color: AppColors.primary),
                                bottom: BorderSide(
                                    width: 1.w, color: AppColors.primary),
                                right: BorderSide(
                                    width: 1.w, color: AppColors.primary),
                              ),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8.r),
                                  right: Radius.circular(8.r)),
                            ),
                            child: CountrySelect(
                              mode: CountrySelectMode.countyOnly,
                              onSelect: (country) {
                                setState(() {
                                  _selectedCountry = country;
                                });

                                print("Esse é o pais de residência: ${_selectedCountry.countryName} ID: ${_selectedCountry.id}");
                              },
                              dropdownHeight: 320.w,
                              dropdownWidth: 330.w,
                              initialCountry: _selectedCountry,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(8.r),
                                      right: Radius.circular(8.r)),
                                  color: AppColors.lightInputColor),
                            ),
                          ),
                          15.verticalSpaceFromWidth,

                          /// First Name
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Nome ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.darkTextColor),
                                  children: [
                                    TextSpan(
                                      text: '(obrigatório)',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              )),
                          11.verticalSpaceFromWidth,
                          NormalInputWidget(
                            controller: _firstNameController,
                            node: _firstNameNode,
                            hint: "Informe seu nome",
                            capitalization: TextCapitalization.words,
                          ),
                          15.verticalSpaceFromWidth,

                          /// Last Name
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Sobrenome ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.darkTextColor),
                                  children: [
                                    TextSpan(
                                      text: '(obrigatório)',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              )),
                          11.verticalSpaceFromWidth,
                          NormalInputWidget(
                            controller: _lastNameController,
                            node: _lastNameNode,
                            hint: "Informe seu sobrenome",
                            capitalization: TextCapitalization.words,
                          ),
                          15.verticalSpaceFromWidth,

                          /// Email
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'E-mail ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.darkTextColor),
                                  children: [
                                    TextSpan(
                                      text: '(obrigatório)',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              )),
                          11.verticalSpaceFromWidth,
                          NormalInputWidget(
                            controller: _emailController,
                            node: _emailNode,
                            hint: "Informe seu email",
                            inputType: TextInputType.emailAddress,
                          ),
                          15.verticalSpaceFromWidth,

                          /// Select Country
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Documento ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.darkTextColor),
                                  children: [
                                    TextSpan(
                                      text: '(obrigatório)',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              )),
                          11.verticalSpaceFromWidth,

                          /// Document: Type and number
                          DocumentInputWidget(
                            textController: _documentController,
                            focusNode: _documentNode,
                            initialCountry: _selectedDocument,
                            onSelect: (country) {
                              setState(() {
                                _selectedDocument = country;
                              });
                              print(
                                  "Esse é o documento selecionado: ${_selectedDocument.documentCode}");
                            },
                          ),
                          30.verticalSpaceFromWidth,
                          if (state.status == RegisterStatus.loading)
                            Center(
                              child: SizedBox(
                                height: 51.w,
                                width: 51.w,
                                child: CircularProgressIndicator(
                                  color: AppColors.lightBlue,
                                  backgroundColor:
                                      AppColors.lightDisabelButtonText,
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              width: 333.w,
                              height: 51.w,
                              child: ElevatedButton(
                                onPressed: (_isFormValid && _platformReady)
                                    ? () {
                                        FocusScope.of(context).unfocus();
                                        print(""
                                            '${_selectedCountry.id}'
                                            '${_firstNameController.text.trim()}'
                                            '${_lastNameController.text.trim()}'
                                            '${_emailController.text.trim()}'
                                            '${_documentController.text.trim()}'
                                            '${_selectedDocument.documentCode}'
                                            '${false}'
                                            '${packageInfo.version}'
                                            '${platform}'
                                            "");
                                        context.read<RegisterBloc>().add(
                                            RegisterSubmitProfileRequested(
                                                countryId: _selectedCountry.id,
                                                name: _firstNameController.text
                                                    .trim(),
                                                surname: _lastNameController
                                                    .text
                                                    .trim(),
                                                email: _emailController.text
                                                    .trim(),
                                                docIdent: _documentController
                                                    .text
                                                    .trim(),
                                                docIdentType: _selectedDocument
                                                    .documentCode,
                                                newsletter: false,
                                                appVersion: packageInfo.version,
                                                deviceOs: platform));
                                      }
                                    : null,
                                child: Text(
                                  "Avançar",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ));
                },
              )),
        ),
      ),
    );
  }
}
