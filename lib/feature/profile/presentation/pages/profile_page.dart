import 'package:bagaer/feature/auth/domain/entities/auth_session.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthSession session;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      session = authState.session;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginAccountDeleted) {
          context.read<AuthBloc>().add(AuthAccountDeleted());
        }
      },
      child: Scaffold(
        // appBar: BagaerAppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  child: Text("logout")),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(DeleteAccountRequested(token: session.accessToken, password: "12345678"));
                  },
                  child: Text("Deletar conta")),
            ),
          ],
        ),
      ),
    );
  }
}
