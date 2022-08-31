// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? shopLoginModel;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        "email": email,
        "password": password,
        "name": name,
        "phone": phone,
      },
    ).then((value) {
      print(value.data);
      shopLoginModel = ShopLoginModel.fromJson(value.data!);

      emit(
        ShopRegisterSuccessState(shopLoginModel!),
      );
    }).catchError((error) {
      print("starrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(error.toString());
      emit(
        ShopRegisterErrorState(error.toString()),
      );
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off;

    emit(
      ShopRegisterChangePasswordVisibilityState(),
    );
  }
}
