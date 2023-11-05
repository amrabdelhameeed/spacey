import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';

// ignore: must_be_immutable
class DefaultTextFormField extends StatefulWidget {
  DefaultTextFormField({
    Key? key,
    required this.hint,
    this.controller,
    this.inputType,
    this.isPassword = false,
    this.validationText,
    this.radius = 20,
  }) : super(key: key);
  final String hint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool isPassword;
  final String? validationText;
  double radius;

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  late bool isPass;

  IconData suffix = Icons.visibility_off_outlined;

  @override
  void initState() {
    isPass = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isPass,
      keyboardType: widget.inputType,
      style: const TextStyle(
        color: AppColors.formFontColor,
      ),
      validator: (error) {
        if (widget.controller!.text.isEmpty) {
          return widget.validationText;
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? MaterialButton(
                elevation: 0,
                onPressed: () {
                  setState(() {
                    isPass = !isPass;
                    suffix = isPass == false ? Icons.visibility_outlined : Icons.visibility_off_outlined;
                  });
                },
                child: Icon(suffix),
              )
            : const SizedBox.shrink(),
        contentPadding: const EdgeInsets.all(20.0),
        hintText: widget.hint,
        errorStyle: const TextStyle(
          fontFamily: 'SFPro',
        ),
        fillColor: const Color(0xFFEFEFEF),
        filled: true,
        hintStyle: const TextStyle(
          fontSize: 15.0,
          color: AppColors.formFontColor,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
// widget.isPassword! ? showPass : false