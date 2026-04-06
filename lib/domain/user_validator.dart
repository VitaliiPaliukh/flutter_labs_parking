class UserValidator {
  const UserValidator._();

  static String? validateName(String value) {
    if (value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name is too short';
    if (RegExp(r'\d').hasMatch(value)) return 'Name must not contain digits';
    return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Email must contain @';
    if (!RegExp(r'^[\w.]+@[\w.]+\.\w+$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'At least 6 characters required';
    return null;
  }

  static String? validateConfirm(String password, String confirm) {
    if (confirm.isEmpty) return 'Please confirm your password';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }

  static String? validatePlate(String value) {
    if (value.isEmpty) return null;
    if (value.length < 3) return 'Plate number too short';
    return null;
  }
}