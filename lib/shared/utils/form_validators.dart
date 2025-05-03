class FormValidators {
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    final alphaRegex = RegExp(r'[A-Za-z]');
    final matchCount = alphaRegex.allMatches(value.trim()).length;
    if (value.trim().length < 3 || matchCount < 3) {
      return 'Username must have at least 3 alphabets';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String originalPassword) {
    if (value == null || value.trim().isEmpty) return 'Confirm your password';
    if (value.trim() != originalPassword.trim()) return 'Passwords do not match';
    return null;
  }
}
