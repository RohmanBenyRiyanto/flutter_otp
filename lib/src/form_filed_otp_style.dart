part of form_input_otp;

class OtpFieldStyle {
  /// The background color for outlined box.
  final Color backgroundColor;

  /// The border color text field.
  final Color borderColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// The border color of text field when disabled.
  final Color disabledBorderColor;

  /// The border color of text field when in focus.
  final Color enabledBorderColor;

  /// The border color of text field when disabled.
  final Color errorBorderColor;

  OtpFieldStyle({
    this.backgroundColor = Colors.transparent,
    this.borderColor = const Color(0xFFCFD8DC),
    this.focusBorderColor = const Color(0xFF025EED),
    this.disabledBorderColor = const Color(0xFFCFD8DC),
    this.enabledBorderColor = const Color(0xFFCFD8DC),
    this.errorBorderColor = const Color(0xFFE11F1F),
  });
}
