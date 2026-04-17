class Validation {
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }

    final password = value.trim();

    if (password.length < 6) return "Minimum 6 characters";
    if (!RegExp(r'[A-Z]').hasMatch(password)) return "Add uppercase letter";
    if (!RegExp(r'[a-z]').hasMatch(password)) return "Add lowercase letter";
    if (!RegExp(r'[0-9]').hasMatch(password)) return "Add a number";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Add special character";
    }

    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "User name is required";
    }

    final username = value.trim();

    if (username.length < 4) return "Minimum 4 characters";
    if (!RegExp(r'[A-Z]').hasMatch(username)) return "Add uppercase letter";
    if (!RegExp(r'[a-z]').hasMatch(username)) return "Add lowercase letter";

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final email = value.trim();

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    // print(emailRegex);

    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email address";
    }

    return null;
  }
}
