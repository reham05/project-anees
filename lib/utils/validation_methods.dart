String? password;

String? fullNameValidator(String? value) {
  const pattern = r'^[a-zA-Z]{0,1000}$';
  final regex = RegExp(pattern);
  if (value!.isEmpty) {
    return "Enter your Full name";
  }
  if (value.contains(' ')) {
    return 'Full name cannot contains spaces';
  }
  if (!regex.hasMatch(value)) {
    return "Invalid name";
  }
  return null;
}

String? phoneValidator(String? value) {
  const pattern = r'^(\+201|01|00201|201)[0-2,5]{1}[0-9]{8}';
  final regex = RegExp(pattern);
  if (value!.isEmpty) {
    return "Enter your phone number";
  }
  if (!regex.hasMatch(value)) {
    return "Enter a valid phone number, e.g:- 01234567891 , 201234567891 or +201234567891";
  }
  return null;
}

String? addressValidator(String? value) {
  if (value!.isEmpty) {
    return "Enter your address";
  }
  return null;
}

String? passwordValidator(String? value) {
  password = value;
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  if (value!.isEmpty) {
    return "Enter your password";
  }
  if (!passValid.hasMatch(value)) {
    return "Password should contain Capital,Small letters & Numbers & Special characters";
  }
  return null;
}

String? confirmPasswordValidator(String? value) {
  if (value!.isEmpty) {
    return "Enter confirm your password";
  }
  if (password != value) {
    return "Passwords don't match";
  }
  return null;
}
