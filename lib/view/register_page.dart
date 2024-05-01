// register_page.dart
import 'package:aynaclient/bloc/AuthBloc/auth_bloc.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_event.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_state.dart';
import 'package:aynaclient/view/home_page.dart';
import 'package:aynaclient/view/utils/extensions/context_extensions.dart';
import 'package:aynaclient/view/utils/extensions/spacer_extension.dart';
import 'package:aynaclient/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            showSuccessToast(message: "Login Success");
            context.push(navigateTo: const HomePage());
          }
          if (state is AuthFailureState) {
            showErrorToast(message: state.error);
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      controller: userNameController,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      controller: passwordController,
                    ),
                    20.vSpace,
                    state is AuthLoadingState
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.hideKeyBoard();
                              String userName = userNameController.text.trim();
                              String password = passwordController.text.trim();
                              if (userName.isEmpty || password.isEmpty) {
                                showErrorToast(
                                  message: "Please fill all fields",
                                );
                                return;
                              }
                              context.bloc<AuthBloc>().add(
                                    RegisterEvent(
                                      username: userName,
                                      password: password,
                                    ),
                                  );
                            },
                            child: const Text('Register'),
                          ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Already have an account? Log in'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
