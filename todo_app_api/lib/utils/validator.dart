import 'form_validator.dart';

class Validator {
  static final requiredValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
  ]);

  static final doubleValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    DoubleValidator(errorText: 'Điểm nhập vào phải là số thực'),
  ]);

  static final usernameValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
  ]);

  static final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  static MultiValidator currentPasswordValidator(String? password) => MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    MatchValidator(password, errorText: 'Current password is wrong'),
  ]);

  static final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  static MultiValidator confirmPasswordValidator(String? password) =>
      MultiValidator([
        RequiredValidator(errorText: 'This field is required'),
        MatchValidator(password, errorText: 'Confirm password is not match'),
      ]);
}
