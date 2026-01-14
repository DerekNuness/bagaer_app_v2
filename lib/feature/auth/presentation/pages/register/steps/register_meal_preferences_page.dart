import 'package:bagaer/core/theme/app_assets.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/chip/chip_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';
import 'package:bagaer/feature/meal_preference/presentation/cubit/meal_preferences_cubit.dart';
import 'package:bagaer/feature/meal_preference/presentation/cubit/meal_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterMealPreferencesPage extends StatefulWidget {
  const RegisterMealPreferencesPage({super.key});

  @override
  State<RegisterMealPreferencesPage> createState() =>
      _RegisterMealPreferencesPageState();
}

class _RegisterMealPreferencesPageState
    extends State<RegisterMealPreferencesPage> {
  final List<MealPreference> _preferenceList = [];

  @override
  void initState() {
    super.initState();
    context.read<MealPreferencesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SizedBox.expand(
        child: BlocBuilder<MealPreferencesCubit, MealPreferencesState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.travelPreferencesImg,
                  width: 144.w,
                  height: 144.w,
                ),
                18.verticalSpaceFromWidth,
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Selecione suas\n",
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkTextColor),
                        children: [
                          TextSpan(
                              text: "preferências de refeição",
                              style: TextStyle(color: AppColors.lightBlue))
                        ])),
                25.verticalSpaceFromWidth,
                SizedBox(
                  width: 348.w,
                  child: Text(
                    "Marque os sabores de sua preferência e nós adaptaremos as recomendações ao seu estilo. Você sempre pode mudar isso. 👍",
                    style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontSize: 16.sp,
                        height: 1.15.w),
                    textAlign: TextAlign.center,
                  ),
                ),
                15.verticalSpaceFromWidth,
                Text(
                  "Selecione pelo menos 3",
                  style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300),
                ),
                25.verticalSpaceFromWidth,
                SizedBox(
                  width: 339.w,
                  height: 270.w,
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        if (state is MealPreferencesLoaded)
                          ...List.generate(state.preferences.length, (index) {
                            final preference = state.preferences[index];
                            final isOnList = _preferenceList
                                .any((pref) => pref.id == preference.id);
                            final isFull = _preferenceList.length >= 5;
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              child: ChipWidget(
                                string:
                                    "${preference.emoji} ${preference.category}",
                                isSelected: isOnList,
                                selectedBorderColor: AppColors.lightBlue,
                                unselectedBorderColor:
                                    AppColors.lightBorderColor,
                                onTap: () {
                                  if (isOnList) {
                                    setState(() {
                                      _preferenceList.removeWhere(
                                          (pref) => pref.id == preference.id);
                                    });
                                  } else {
                                    if (!isFull) {
                                      setState(() {
                                        _preferenceList.add(preference);
                                      });
                                    }
                                  }
                                },
                              ),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  // 👇 vem de cima
                                  offset: Offset(0, -(1 - value) * 20),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                            );
                          })
                        else
                          ...List.generate(
                            12,
                            (index) => ChipShimmerWidget(
                              width: 60.w +
                                  (index % 3) * 20.w, // larguras variadas
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpaceFromWidth,
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
                        onPressed: (_preferenceList.length >= 3)
                            ? () {
                                final _idList =
                                    _preferenceList.map((p) => p.id).toList();
                                context.read<RegisterBloc>().add(
                                    RegisterSubmitMealPrefsRequested(_idList));
                              }
                            : null,
                        style: ButtonStyle(backgroundColor:
                            WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.disabled)) {
                              return AppColors.lightDisabelButton;
                            }

                            if (_preferenceList.length >= 3) {
                              return AppColors.lightBlue;
                            }

                            return AppColors.lightDisabelButton;
                          },
                        ), surfaceTintColor:
                            WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.disabled)) {
                              return AppColors.lightDisabelButtonText;
                            }

                            if (_preferenceList.length >= 3) {
                              return Colors.white;
                            }

                            return AppColors.lightDisabelButtonText;
                          },
                        ), elevation: WidgetStateProperty.resolveWith<double>(
                          (states) {
                            if (states.contains(WidgetState.disabled)) {
                              return 0;
                            }

                            if (_preferenceList.length >= 3) {
                              return 1;
                            }

                            return 0;
                          },
                        )),
                        child: Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    )));
  }
}
