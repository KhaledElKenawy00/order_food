import 'package:flutter/material.dart';
import 'package:task2/model/user_model.dart';
import '../controllers/calorie_controller.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  double? _calories;

  UserModel? get user => _user;
  double? get calories => _calories;

  void setUser(UserModel user) {
    _user = user;
    _calories = CalorieController.calculateCalories(user);
    notifyListeners();
  }
}
