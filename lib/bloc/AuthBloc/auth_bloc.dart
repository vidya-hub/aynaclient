import 'dart:convert';
import 'package:aynaclient/bloc/AuthBloc/auth_event.dart';
import 'package:aynaclient/bloc/AuthBloc/auth_state.dart';
import 'package:aynaclient/model/user_model.dart';
import 'package:aynaclient/service/hive_service.dart';
import 'package:aynaclient/service/http_service.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      http.Response loginResponse = await HttpService.login(
        event.username,
        event.password,
      );
      Map body = jsonDecode(loginResponse.body);
      if (loginResponse.statusCode == 200) {
        await HiveService.saveUsername(User(event.username));
        emit(AuthSuccessState());
        return;
      }
      emit(AuthFailureState(error: body["message"]));
    });
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      http.Response loginResponse = await HttpService.register(
        event.username,
        event.password,
      );
      Map body = jsonDecode(loginResponse.body);
      if (loginResponse.statusCode == 200) {
        await HiveService.saveUsername(User(event.username));
        emit(AuthSuccessState());
        return;
      }
      emit(AuthFailureState(error: body["message"]));
    });
  }
}
