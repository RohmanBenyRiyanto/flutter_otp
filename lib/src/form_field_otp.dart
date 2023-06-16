part of form_input_otp;

class FormFieldOTP extends StatefulWidget {
  /// TextField Controller
  final FormOtpController? controller;

  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// space between the text fields
  final double filedPadding;

  /// content padding of the text fields
  final EdgeInsets contentPadding;

  /// Manage the type of keyboard that shows up
  final TextInputType keyboardType;

  /// show the error border or not
  final bool hasError;

  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The style to use for the text being edited.
  final double outlineBorderRadius;

  /// Text Field Alignment
  /// default: MainAxisAlignment.filedPadding [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  /// space).
  final bool isDense;

  /// Text Field Style
  final OtpFieldStyle? otpFieldStyle;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  final List<TextInputFormatter>? inputFormatter;

  /// Border width of the OTP Fields
  final double borderWidth;

  const FormFieldOTP({
    Key? key,
    this.length = 4,
    this.width = 10,
    this.controller,
    this.fieldWidth = 30,
    this.filedPadding = 0,
    this.otpFieldStyle,
    this.hasError = false,
    this.keyboardType = TextInputType.number,
    this.style = const TextStyle(),
    this.outlineBorderRadius = 10,
    this.textCapitalization = TextCapitalization.none,
    this.textFieldAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.fieldStyle = FieldStyle.underline,
    this.onChanged,
    this.inputFormatter,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.isDense = false,
    this.onCompleted,
    this.borderWidth = 1.0,
  })  : assert(length > 1),
        super(key: key);

  @override
  FormFieldOTPState createState() => FormFieldOTPState();
}

class FormFieldOTPState extends State<FormFieldOTP> {
  late OtpFieldStyle _otpFieldStyle;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  late List<String> _pin;

  @override
  void initState() {
    super.initState();

    /// Set the default value for the otp fields
    if (widget.controller != null) {
      widget.controller!.setFormFieldOTPState(this);
    }

    /// Set the default value for the otp fields
    if (widget.otpFieldStyle == null) {
      _otpFieldStyle = OtpFieldStyle();
    } else {
      _otpFieldStyle = widget.otpFieldStyle!;
    }

    /// Initialize the focus nodes
    _focusNodes = List<FocusNode?>.filled(widget.length, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.length, null,
        growable: false);

    /// Initialize the pin
    _pin = List.generate(widget.length, (int i) {
      return '';
    });
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return buildTextField(context, index);
        }),
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? textEditingController = _textControllers[index];

    // if focus node doesn't exist, create it.
    if (focusNode == null) {
      _focusNodes[index] = FocusNode();
      focusNode = _focusNodes[index];
      focusNode?.addListener((() => handleFocusChange(index)));
    }
    if (textEditingController == null) {
      _textControllers[index] = TextEditingController();
      textEditingController = _textControllers[index];
    }

    final isLast = index == widget.length - 1;

    InputBorder getBorder(Color color) {
      final colorOrError =
          widget.hasError ? _otpFieldStyle.errorBorderColor : color;

      return widget.fieldStyle == FieldStyle.box
          ? OutlineInputBorder(
              borderSide: BorderSide(
                color: colorOrError,
                width: widget.borderWidth,
              ),
              borderRadius: BorderRadius.circular(widget.outlineBorderRadius),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorOrError,
                width: widget.borderWidth,
              ),
            );
    }

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0 : widget.filedPadding,
      ),
      child: TextField(
        controller: _textControllers[index],
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textAlign: TextAlign.center,
        style: widget.style,
        inputFormatters: widget.inputFormatter,
        maxLength: 1,
        focusNode: _focusNodes[index],
        obscureText: widget.obscureText,
        contextMenuBuilder: (
          BuildContext context,
          EditableTextState editableTextState,
        ) {
          return AdaptiveTextSelectionToolbar.editable(
            anchors: editableTextState.contextMenuAnchors,
            clipboardStatus: ClipboardStatus.pasteable,
            onCopy: () => _handleCopy(),
            onCut: () => _handleCut(),
            onPaste: () => _handlePaste(),
            onSelectAll: () => _handleSelectAll(),
          );
        },
        decoration: InputDecoration(
          isDense: widget.isDense,
          filled: true,
          fillColor: _otpFieldStyle.backgroundColor,
          counterText: "",
          contentPadding: widget.contentPadding,
          border: getBorder(_otpFieldStyle.borderColor),
          focusedBorder: getBorder(_otpFieldStyle.focusBorderColor),
          enabledBorder: getBorder(_otpFieldStyle.enabledBorderColor),
          disabledBorder: getBorder(_otpFieldStyle.disabledBorderColor),
          errorBorder: getBorder(_otpFieldStyle.errorBorderColor),
          focusedErrorBorder: getBorder(_otpFieldStyle.errorBorderColor),
          errorText: null,
          // to hide the error text
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (String str) {
          if (str.length > 1) {
            _handlePaste();
            return;
          }

          // Check if the current value at this position is empty
          // If it is move focus to previous text field.
          if (str.isEmpty) {
            if (index == 0) return;
            _focusNodes[index]!.unfocus();
            _focusNodes[index - 1]!.requestFocus();
          }

          // Update the current pin
          setState(() {
            _pin[index] = str;
          });

          // Remove focus
          if (str.isNotEmpty) _focusNodes[index]!.unfocus();
          // Set focus to the next field if available
          if (index + 1 != widget.length && str.isNotEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }

          String currentPin = _getCurrentPin();

          // if there are no null values that means otp is completed
          // Call the `onCompleted` callback function provided
          if (!_pin.contains(null) &&
              !_pin.contains('') &&
              currentPin.length == widget.length) {
            widget.onCompleted?.call(currentPin);
          }

          // Call the `onChanged` callback function
          // widget.onChanged!(currentPin);

          // nullable widget.onChanged
          if (widget.onChanged != null) {
            widget.onChanged!(currentPin);
          }
        },
      ),
    );
  }

  void handleFocusChange(int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? controller = _textControllers[index];

    if (focusNode == null || controller == null) return;

    if (focusNode.hasFocus) {
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  String _getCurrentPin() {
    String currentPin = "";
    for (var value in _pin) {
      currentPin += value;
    }
    return currentPin;
  }

  void _handlePaste() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      String str = clipboardData.text ?? '';

      // Menghapus karakter yang tidak valid, seperti spasi atau karakter non-digit
      str = str.replaceAll(RegExp(r'[^0-9]'), '');

      // Mengambil panjang form dari widget.length
      int formLength = widget.length;

      // Memotong string sesuai panjang form yang diinginkan
      if (str.length > formLength) {
        str = str.substring(0, formLength);
      }

      // Mengisi form OTP
      for (int i = 0; i < formLength; i++) {
        if (i < str.length) {
          String digit = str.substring(i, i + 1);
          _textControllers[i]!.text = digit;
          _pin[i] = digit;
        } else {
          _textControllers[i]!.text = '';
          _pin[i] = "";
        }
      }

      // Fokus ke form terakhir
      // ignore: use_build_context_synchronously
      FocusScope.of(context).requestFocus(_focusNodes[formLength - 1]);

      // Mendapatkan pin saat ini
      String currentPin = _getCurrentPin();

      // Jika tidak ada nilai null pada pin dan pin telah terisi lengkap
      // Panggil callback `onCompleted`
      if (!_pin.contains(null) &&
          !_pin.contains('') &&
          currentPin.length == formLength) {
        widget.onCompleted?.call(currentPin);
      }

      // Panggil callback `onChanged`
      if (widget.onChanged != null) {
        widget.onChanged!(currentPin);
      }
    }
  }

  _handleCopy() {
    // copy all the text controllers values
    String data = "";

    for (int i = 0; i < _textControllers.length; i++) {
      data += _textControllers[i]!.text;
    }

    Clipboard.setData(ClipboardData(text: data));
  }

  _handleCut() {
    // copy all the text controllers values and clear them
    String data = "";

    for (int i = 0; i < _textControllers.length; i++) {
      data += _textControllers[i]!.text;
      _textControllers[i]!.text = "";
      _pin[i] = "";
    }

    Clipboard.setData(ClipboardData(text: data));
  }

  _handleSelectAll() {
    // select all text
    for (int i = 0; i < _textControllers.length; i++) {
      _textControllers[i]!.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textControllers[i]!.text.length,
      );
    }
  }
}

class FormOtpController {
  late FormFieldOTPState _formFieldOTPState;

  void setFormFieldOTPState(FormFieldOTPState state) {
    _formFieldOTPState = state;
  }

  void clear() {
    final textFieldLength = _formFieldOTPState.widget.length;
    _formFieldOTPState._pin = List.generate(textFieldLength, (int i) {
      return '';
    });

    final textControllers = _formFieldOTPState._textControllers;
    for (var textController in textControllers) {
      if (textController != null) {
        textController.text = '';
      }
    }

    final firstFocusNode = _formFieldOTPState._focusNodes[0];
    if (firstFocusNode != null) {
      firstFocusNode.requestFocus();
    }
  }

  void set(List<String> pin) {
    final textFieldLength = _formFieldOTPState.widget.length;
    if (pin.length < textFieldLength) {
      throw Exception(
          "Pin length must be same as field length. Expected: $textFieldLength, Found ${pin.length}");
    }

    _formFieldOTPState._pin = pin;
    String newPin = '';

    final textControllers = _formFieldOTPState._textControllers;
    for (int i = 0; i < textControllers.length; i++) {
      final textController = textControllers[i];
      final pinValue = pin[i];
      newPin += pinValue;

      if (textController != null) {
        textController.text = pinValue;
      }
    }

    final widget = _formFieldOTPState.widget;

    widget.onChanged?.call(newPin);

    widget.onCompleted?.call(newPin);
  }

  void setValue(String value, int position) {
    final maxIndex = _formFieldOTPState.widget.length - 1;
    if (position > maxIndex) {
      throw Exception(
          "Provided position is out of bounds for the FormFieldOTP");
    }

    final textControllers = _formFieldOTPState._textControllers;
    final textController = textControllers[position];
    final currentPin = _formFieldOTPState._pin;

    if (textController != null) {
      textController.text = value;
      currentPin[position] = value;
    }

    String newPin = "";
    for (var item in currentPin) {
      newPin += item;
    }

    final widget = _formFieldOTPState.widget;
    if (widget.onChanged != null) {
      widget.onChanged!(newPin);
    }
  }

  void setFocus(int position) {
    final maxIndex = _formFieldOTPState.widget.length - 1;
    if (position > maxIndex) {
      throw Exception(
          "Provided position is out of bounds for the FormFieldOTP");
    }

    final focusNodes = _formFieldOTPState._focusNodes;
    final focusNode = focusNodes[position];

    if (focusNode != null) {
      focusNode.requestFocus();
    }
  }
}
