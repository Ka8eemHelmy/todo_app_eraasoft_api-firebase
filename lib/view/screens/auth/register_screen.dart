import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_shared/view_model/servises/local/shared_keys.dart';
import 'package:todo_shared/view_model/servises/local/shared_preference.dart';

import '../../../view_model/bloc/login_cubit/login_cubit.dart';
import '../../../view_model/bloc/login_cubit/login_state.dart';
import '../../../view_model/navigation.dart';
import '../Task_screen/tasks_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is CheckLoginSuccessState) {
                  // Fluttertoast.showToast(
                  //   msg: "Welcome To Our App MR.${SharedPreference.get(SharedKeys.userName)}",
                  //   // toastLength: Toast.LENGTH_SHORT,
                  //   gravity: ToastGravity.BOTTOM,
                  //   // timeInSecForIosWeb: 1,
                  //   backgroundColor: Colors.green,
                  //   // textColor: Colors.white,
                  //   // fontSize: 16.0
                  // );
                  // Navigation.goPush(context, TasksScreen());
                } else if (state is CheckLoginErrorState) {
                  // Fluttertoast.showToast(
                  //   msg: state.error,
                  //   // toastLength: Toast.LENGTH_SHORT,
                  //   gravity: ToastGravity.BOTTOM,
                  //   // timeInSecForIosWeb: 1,
                  //   backgroundColor: Colors.red,
                  //   // textColor: Colors.white,
                  //   // fontSize: 16.0
                  // );
                }
              },
              builder: (context, state) {
                var cubit = LoginCubit.get(context);
                return Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: Image.asset('assets/logo.png').image,
                          ),
                          PositionedDirectional(
                            bottom: -20.h,
                            end: -20.w,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: Image.asset('assets/logo.png').image,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Please Enter The Details of Bellow to Continue',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: cubit.emailController,
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.red,
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.red,
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),
                        onChanged: (value) {
                          print(value);
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: cubit.passwordController,
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.obscure,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.red,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                cubit.showPassword();
                              },
                              icon: Icon(
                                cubit.obscure ? Icons.visibility : Icons.visibility_off,
                                color: cubit.obscure ? Colors.grey : Colors.red,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.red,
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))),
                        onChanged: (value) {
                          print(value);
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please, Enter Password';
                          } else if (value.trim().length < 8) {
                            return 'Your Password must be large than 8 Characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0.r),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              // cubit.checkLogin();
                              cubit.registerNewUser();
                              // print(FirebaseAuth.instance.currentUser?.emailVerified);
                            }
                          },
                          child: state is CheckLoginLoadingState
                              ? CircularProgressIndicator.adaptive()
                              : Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
