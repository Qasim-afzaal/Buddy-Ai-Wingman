import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:buddy/bloc/auth/auth_bloc.dart';
import 'package:buddy/bloc/auth/auth_event.dart';
import 'package:buddy/bloc/auth/auth_state.dart';

class SplashBlocPage extends StatelessWidget {
  const SplashBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthSplashInitialized()),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthNavigationRequired) {
              if (state.arguments != null) {
                Get.offNamed(state.route, arguments: state.arguments);
              } else {
                Get.offNamed(state.route);
              }
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_background2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      if (state is AuthLoading)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      else
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}