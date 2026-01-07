import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
//Helpers

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? width, height, radius;
  final int? maxLength;
  final String? floatingText, hintText;
  final TextStyle hintStyle, errorStyle, inputStyle;
  final TextStyle? floatingStyle;
  final EdgeInsets? contentPadding;
  final void Function(String? value)? onSaved, onChanged;
  final VoidCallback? onTap;
  final Widget? prefix;
  final bool showCursor;
  final bool autofocus;
  final bool showErrorBorder;
  final TextAlign textAlign;
  final Alignment errorAlign, floatingAlign;
  final Color? fillColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxlines;
  final String? Function(String? value) validator;

  const CustomTextField({
    Key? key,
    this.controller,
    this.width,
    this.height = 40,
    this.radius = 40,
    this.maxlines = 1,
    this.maxLength,
    this.floatingText,
    this.floatingStyle,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.prefix,
    this.showCursor = true,
    this.showErrorBorder = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.errorAlign = Alignment.centerRight,
    this.floatingAlign = Alignment.centerLeft,
    this.fillColor,
    this.hintText,
    this.hintStyle = const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),
    this.errorStyle = const TextStyle(
      height: 0,
      color: Colors.transparent,
    ),
    this.inputStyle = const TextStyle(
      fontSize: 17,
      color: ColorResources.THEMECOLOR,
    ),
    this.contentPadding = const EdgeInsets.fromLTRB(17, 14, 1, 14),
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;
  bool hidePassword = true;

  bool get hasError => errorText != null;

  bool get showErrorBorder => widget.showErrorBorder && hasError;

  bool get hasFloatingText => widget.floatingText != null;

  bool get isPasswordField =>
      widget.keyboardType == TextInputType.visiblePassword;

  void _onSaved(String? value) {
    value = value!.trim();
    widget.controller?.text = value;
    widget.onSaved?.call(value);
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) {
      _runValidator(value);
      widget.onChanged!(value);
    }
  }

  String? _runValidator(String? value) {
    final error = widget.validator(value!.trim());
    setState(() {
      errorText = error;
    });
    return error;
  }

  void _togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
      borderSide: const BorderSide(
        color: ColorResources.THEMECOLOR,
      ),
    );
  }

  OutlineInputBorder _normalBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
      borderSide: const BorderSide(color: Colors.grey),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Floating text
        if (hasFloatingText) ...[
          SizedBox(
            width: widget.width,
            child: Align(
              alignment: widget.floatingAlign,
              child: Text(
                widget.floatingText!,
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],

        //TextField
        TextFormField(
          onTap: widget.onTap,
          controller: widget.controller,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          maxLines: widget.maxlines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          style: widget.inputStyle,
          showCursor: widget.showCursor,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textAlignVertical: TextAlignVertical.center,
          autovalidateMode: AutovalidateMode.disabled,
          cursorColor: ColorResources.THEMECOLOR,
          obscureText: isPasswordField && hidePassword,
          validator: _runValidator,
          onFieldSubmitted: _runValidator,
          onSaved: _onSaved,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            errorStyle: widget.errorStyle,
            fillColor: widget.fillColor,
            prefixIcon: widget.prefix,
            contentPadding: widget.contentPadding,
            isDense: true,
            counterText: '',
            enabledBorder: _normalBorder(),
            border: InputBorder.none,
            focusedBorder: _focusedBorder(),
            focusedErrorBorder: _focusedBorder(),
            errorBorder: showErrorBorder ? _errorBorder() : null,
            suffixIcon: isPasswordField
                ? InkWell(
                    onTap: _togglePasswordVisibility,
                    child: const Icon(
                      Icons.remove_red_eye_sharp,
                      color: Colors.grey,
                      size: 22,
                    ),
                  )
                : null,
          ),
        ),

        //Error text
        if (hasError) ...[
          const SizedBox(height: 2),
          SizedBox(
            width: widget.width,
            child: Align(
              alignment: widget.errorAlign,
              child: Text(
                errorText!,
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
