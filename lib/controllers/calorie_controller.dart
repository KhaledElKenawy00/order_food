import 'package:task2/model/user_model.dart';

class CalorieController {
  static double calculateCalories(UserModel user) {
    if (user.gender.toLowerCase() == 'female') {
      return 655.1 +
          (9.56 * user.weight) +
          (1.85 * user.height) -
          (4.67 * user.age);
    } else {
      return 666.47 +
          (13.75 * user.weight) +
          (5 * user.height) -
          (6.75 * user.age);
    }
  }
}
