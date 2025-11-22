import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';

class PhoneInputRow extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onCountryCodeChanged;

  const PhoneInputRow({
    Key? key,
    required this.controller,
    this.onCountryCodeChanged,
  }) : super(key: key);

  @override
  State<PhoneInputRow> createState() => _PhoneInputRowState();
}

class _PhoneInputRowState extends State<PhoneInputRow> {
  String _countryCode = '+221';
  String _countryFlag = '🇸🇳';

  String get fullPhoneNumber => '$_countryCode${widget.controller.text}';

  @override
  void initState() {
    super.initState();
    // Notifier le code pays initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCountryCodeChanged?.call(_countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _countryFlag,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _countryCode,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.phoneHint,
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
