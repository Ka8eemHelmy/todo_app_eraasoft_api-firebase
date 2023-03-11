abstract class LoginState {}

class InitLoginState extends LoginState {}

class ShowPasswordState extends LoginState {}

class CheckLoginLoadingState extends LoginState {}

class CheckLoginSuccessState extends LoginState {}

class CheckLoginErrorState extends LoginState {
  String error;
  CheckLoginErrorState(this.error);
}
