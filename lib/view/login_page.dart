import 'package:aynaclient/bloc/AuthBloc/auth_bloc.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_event.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_state.dart';
import 'package:aynaclient/view/home_page.dart';
import 'package:aynaclient/view/register_page.dart';
import 'package:aynaclient/view/utils/extensions/context_extensions.dart';
import 'package:aynaclient/view/utils/extensions/spacer_extension.dart';
import 'package:aynaclient/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            showSuccessToast(message: "Login Success");
            context.push(navigateTo: const HomePage());
          }
          if (state is AuthFailureState) {
            showErrorToast(
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        controller: userNameController,
                      ),
                      TextField(
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        controller: passwordController,
                      ),
                      20.vSpace,
                      state is AuthLoadingState
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: const Text('Login'),
                            ),
                      10.vSpace,
                      TextButton(
                        onPressed: () {
                          context.push(navigateTo: RegisterPage());
                        },
                        child: const Text('Create an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void login() {
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
          LoginEvent(
            username: userName,
            password: password,
          ),
        );
  }
}
