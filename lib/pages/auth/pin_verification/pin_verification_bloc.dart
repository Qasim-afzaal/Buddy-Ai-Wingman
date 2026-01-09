import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/bloc/auth/auth_bloc.dart';
import 'package:buddy/bloc/auth/auth_event.dart';
import 'package:buddy/bloc/auth/auth_state.dart';

class PinVerificationBlocPage extends StatefulWidget {
  const PinVerificationBlocPage({super.key});

  @override
  State<PinVerificationBlocPage> createState() => _PinVerificationBlocPageState();
}

class _PinVerificationBlocPageState extends State<PinVerificationBlocPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("PIN Verification"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Enter your PIN to continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "PIN",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    utils.showToast(message: state.message);
                  } else if (state is AuthNavigationRequired) {
                    if (state.arguments != null) {
                      Get.offNamed(state.route, arguments: state.arguments);
                    } else {
                      Get.offNamed(state.route);
                    }
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading ? null : () {
                      if (_pinController.text.isNotEmpty) {
                        context.read<AuthBloc>().add(
                          AuthPinLoginRequested(pin: _pinController.text),
                        );
                      } else {
                        utils.showToast(message: "Please enter your PIN");
                      }
                    },
                    child: state is AuthLoading 
                        ? CircularProgressIndicator()
                        : Text("Verify PIN"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
