import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BnTextField extends StatefulWidget {
  final String? name;
  final TextEditingController? controler;
  final FocusNode? focus;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool password;
  final Icon? prefixIcon;
  final bool dismissOnTapOutside;
  final Widget? suffix;
  final TextStyle? style;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final bool enable;
  final String? helperText;
  final String? initialValue;
  final bool border;
  final int maxLine;

  const BnTextField(
      {super.key,
      this.name,
      this.controler,
      this.dismissOnTapOutside = false,
      this.focus,
      this.suffix,
      this.prefixIcon,
      this.validator,
      this.keyboardType,
      this.password = false,
      this.style,
      this.onSubmit,
      this.onChange,
      this.enable = true,
      this.initialValue,
      this.border = false,
      this.maxLine = 1,
      this.helperText});

  @override
  State<BnTextField> createState() => _BnTextFieldState();
}

class _BnTextFieldState extends State<BnTextField> {
  late bool _obscured;

  @override
  void initState() {
    _obscured = widget.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      enabled: widget.enable,
      maxLines: widget.keyboardType == TextInputType.multiline ? widget.maxLine + 1 : 1,
      minLines: widget.keyboardType == TextInputType.multiline ? widget.maxLine + 1 : null,
      inputFormatters: widget.maxLine == 1
          ? null
          : [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.split('\n').length > widget.maxLine) return oldValue;
                return newValue;
              })
            ],
      onTapOutside: (event) {
        if (widget.dismissOnTapOutside) FocusManager.instance.primaryFocus?.unfocus();
      },
      initialValue: widget.initialValue,
      controller: widget.controler,
      focusNode: widget.focus,
      validator: (value) {
        return widget.validator?.call(value);
      },
      onFieldSubmitted: widget.onSubmit,
      onChanged: widget.onChange,
      style: widget.style,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      enableSuggestions: !widget.password,
      autocorrect: !widget.password,
      decoration: InputDecoration(
        helperText: widget.helperText,
        border: widget.border ? OutlineInputBorder() : null,
        helperMaxLines: 5,
        isDense: true,
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: widget.password && widget.prefixIcon == null ? const Icon(Icons.lock_rounded, size: 24) : centerPrfix(),
        suffix: widget.password
            ? Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: GestureDetector(
                  onTap: _toggleObscured,
                  child: Icon(
                    _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    size: 15,
                  ),
                ),
              )
            : widget.suffix,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        labelText: widget.name,
        labelStyle: widget.style,
        errorMaxLines: 5,
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (widget.focus?.hasPrimaryFocus ?? false) return; // If focus is on text field, dont unfocus
      widget.focus?.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  centerPrfix() {
    var child = widget.prefixIcon;
    return widget.maxLine > 1
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 80),
            child: child,
          )
        : child;
  }
}
