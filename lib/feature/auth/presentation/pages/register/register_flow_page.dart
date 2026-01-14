import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/register_flow_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFlowPage extends StatelessWidget {
  const RegisterFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>()..add(RegisterResetRequested()),
      child: const RegisterFlowView(),
    );
  }
}