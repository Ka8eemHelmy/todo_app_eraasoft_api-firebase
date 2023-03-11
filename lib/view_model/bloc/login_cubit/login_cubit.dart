import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_shared/view_model/servises/local/shared_keys.dart';
import 'package:todo_shared/view_model/servises/local/shared_preference.dart';
import 'package:todo_shared/view_model/servises/network/DioHelper.dart';
import 'package:todo_shared/view_model/servises/network/endPoints.dart';
import '../../../model/user/user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitLoginState());

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool obscure = true;

  void showPassword() {
    obscure = !obscure;
    emit(ShowPasswordState());
  }

  UserModel? user;

  void checkLogin() {
    emit(CheckLoginLoadingState());
    DioHelper.post(
      endPoint: login,
      data: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    ).then((value) {
      print(value.data);
      user = UserModel.fromJson(value.data);
      if (user != null) {
        cashUserDate(user!);
      }
      emit(CheckLoginSuccessState());
    }).catchError((onError) {
      if (onError is DioError) {
        print(onError.response?.data);
        emit(CheckLoginErrorState(onError.response?.data['message'].toString() ?? 'Error Login'));
      }
    });
  }

  void cashUserDate(UserModel user) {
    SharedPreference.set(SharedKeys.userId, user.user?.id);
    SharedPreference.set(SharedKeys.userName, user.user?.name);
    SharedPreference.set(SharedKeys.userToken, user.authorisation?.token);
  }

  void registerNewUser() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      print(value.user?.email);
      print('User Created Successfully');
      addUserToFireStore();
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void addUserToFireStore() {
    FirebaseFirestore.instance
        .collection('users')
        .add(
          {
            'uid': FirebaseAuth.instance.currentUser?.uid,
            'email': FirebaseAuth.instance.currentUser?.email,
            'password': passwordController.text,
          },
        )
        .then((value) => print('Add User To FireStore Successfully'))
        .catchError((onError) {
          print('Add User To FireStore Error $onError');
        });
  }

  void loginFirebase() {
    emit(CheckLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      print(value.user?.email);
      print('Login Successfully');
      emit(CheckLoginSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(CheckLoginErrorState(onError.toString() ?? 'Error Login'));
    });
  }
}
