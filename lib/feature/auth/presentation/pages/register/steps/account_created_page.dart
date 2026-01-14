import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/appbar/bagaer_app_bar.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class AccountCreatedPage extends StatefulWidget {
  const AccountCreatedPage({super.key});

  @override
  State<AccountCreatedPage> createState() => _AccountCreatedPageState();
}

class _AccountCreatedPageState extends State<AccountCreatedPage> with TickerProviderStateMixin {
  late final fileLoader = FileLoader.fromAsset(
    "assets/animations/check_animation.riv",
    riveFactory: Factory.rive,
  );
  
  bool _showContent = false;
  bool _listenerAdded = false;

  /// Keys para o começo das animações
  bool _showTitle = false;
  bool _showSubtitle = false;
  bool _showButton = false;

  void _startStaggeredAnimations() async {
    setState(() => _showTitle = true);
    print(_showTitle);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showSubtitle = true);
    print(_showTitle);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showButton = true);
    print(_showButton);
  }

  void _onRiveEvent(Event event) {
    final isFinished = event.booleanProperty("isFinished");
    if (isFinished != null && isFinished.value == true) {
      // setState(() {
      //   _showContent = true;
      //   print("Evento foi reconhecido");
      // });
      print("Evento foi reconhecido");
      _startStaggeredAnimations();
    }
  }

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BagaerAppBar(
        showBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(21.w, 20.h, 21.w, 27.h),
          child: Column(
            children: [
              Expanded(
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuart,
                  alignment: _showContent ? Alignment.topCenter : Alignment.center,
                  child: SizedBox(
                    height: 280.w,
                    child: RiveWidgetBuilder(
                      fileLoader: fileLoader, 
                      builder: (context, state) => switch (state) {
                        RiveLoading() => const Center(child: CircularProgressIndicator()),
                        RiveFailed() => ErrorWidget.withDetails(
                          message: state.error.toString(),
                          error: FlutterError(state.error.toString()),
                        ),
                        RiveLoaded() => Builder(
                          builder: (context) {
                            // Add listener only once
                            if (!_listenerAdded) {
                              state.controller.stateMachine.addEventListener(_onRiveEvent);
                              _listenerAdded = true;
                            }
                            return RiveWidget(
                              controller: state.controller,
                              fit: Fit.fitHeight,
                            );
                          },
                        ),
                      }
                    )
                  ),
                ),
              ),
              // Show content conditionally based on _showContent
              Column(
                children: [
                  AnimatedSlide(
                    offset: _showTitle ? Offset.zero : const Offset(0, 0.01),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: _showTitle ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Parabéns!\n',
                          style: TextStyle(
                            fontSize: 32.sp, 
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sua conta ',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Bagaer ',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: 'foi criada.',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpaceFromWidth,
                  AnimatedSlide(
                    offset: _showSubtitle ? Offset.zero : const Offset(0, 0.2),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: _showSubtitle ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: SizedBox(
                        width: 350.w,
                        child: Text(
                          "Para cuidar melhor de você, da sua bagagem e da sua viagem, precisamos de mais algumas informações.",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  150.verticalSpaceFromWidth,
                  AnimatedSlide(
                    offset: _showButton ? Offset.zero : const Offset(0, 0.2),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: _showButton ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: ElevatedButton(
                        onPressed: (){
                          context.read<RegisterBloc>().add(RegisterGoToProfileData());
                        }, 
                        child: Text(
                          "Continuar"
                        )
                      ),
                    ),
                  ),
                  20.verticalSpaceFromWidth,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}