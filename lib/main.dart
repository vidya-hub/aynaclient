// main.dart
import 'package:aynaclient/app.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_bloc.dart';
import 'package:aynaclient/bloc/socket_cubit/socket_cubit.dart';
import 'package:aynaclient/service/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<SocketCubit>(
          create: (context) => SocketCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const App(),
        title: 'Flutter Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
