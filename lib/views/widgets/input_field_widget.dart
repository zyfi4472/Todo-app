import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Icon icon;
  final String heading;
  final String labelText;
  final bool obscureText;

  const InputField({
    Key? key,
    this.obscureText = false, // Default value is false (not obscured)
    required this.onChanged,
    required this.icon,
    required this.heading,
    required this.labelText,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused =
          _focusNode.hasFocus || _textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.heading,
            style: const TextStyle(
              color: Color(0XFF393349),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: widget.obscureText, // Use the obscureText property
            focusNode: _focusNode,
            controller: _textEditingController,
            onChanged: (value) {
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              labelText: _isFocused ? null : widget.labelText,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0XFF393349)),
                borderRadius: BorderRadius.circular(10.0.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0XFF393349)),
                borderRadius: BorderRadius.circular(10.0.r),
              ),
              filled: true,
              fillColor: const Color(0XFFF8F8F8),
              prefixIcon: widget.icon,
            ),
          ),
        ],
      ),
    );
  }
}
