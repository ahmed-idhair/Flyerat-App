import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as intl_phone;
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../config/app_theme.dart';
import '../../translations/lang_keys.dart';
import 'app_custom_text.dart';

class AppPhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool isRequired;
  final void Function(PhoneData)? onPhoneChanged;
  final TextInputAction? textInputAction;

  // Initial values
  final String initialPhoneCode;
  final String initialCountryCode;
  final String initialFlag;
  final String? initialPhoneNumber;

  const AppPhoneInput({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.enabled = true,
    this.onPhoneChanged,
    this.textInputAction,
    this.initialPhoneCode = '962',
    this.initialCountryCode = 'JO',
    this.initialFlag = '🇯🇴',
    this.initialPhoneNumber,
    this.isRequired = true,
  });

  /// Parse a full phone number into country code and local number
  static Future<void> parsePhoneNumber(
    String? mobile,
    TextEditingController phoneController,
    RxString phoneCode,
    RxString countryCode,
  ) async {
    if (mobile == null || mobile.isEmpty) return;

    try {
      intl_phone.PhoneNumber phoneNumber = await intl_phone
          .PhoneNumber.getRegionInfoFromPhoneNumber(mobile);

      if (phoneNumber.phoneNumber != null) {
        phoneController.text = phoneNumber.phoneNumber!.replaceAll(
          "+${phoneNumber.dialCode}",
          "",
        );
        if (kDebugMode) {
          print('Log dialCode ${phoneNumber.dialCode}');
          print('Log isoCode ${phoneNumber.isoCode}');
        }
        phoneCode.value = phoneNumber.dialCode ?? "962";
        countryCode.value = phoneNumber.isoCode ?? "JO";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing phone number: $e');
      }
    }
  }

  /// Validate phone number based on country code
  static Future<PhoneValidationResult> validateMobile(
    PhoneData phoneData,
  ) async {
    try {
      // Convert country code string to IsoCode
      final isoCode = IsoCode.values.firstWhere(
        (iso) => iso.name == phoneData.countryCode.toUpperCase(),
        orElse: () => IsoCode.US, // Default fallback
      );

      // Parse the phone number
      final parsedPhoneNumber = PhoneNumber.parse(
        phoneData.phoneNumber,
        callerCountry: isoCode,
      );

      // Check if valid
      final isValid = parsedPhoneNumber.isValid();

      // Return the validation result with formatted number
      return PhoneValidationResult(
        isValid: isValid,
        formattedNumber: parsedPhoneNumber.nsn, // National Significant Number
        fullNumber:
            "+${phoneData.phoneCode}${parsedPhoneNumber.nsn}", // Full international format
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error validating phone number: $e');
      }
      return PhoneValidationResult(
        isValid: false,
        formattedNumber: phoneData.phoneNumber,
        fullNumber: "+${phoneData.phoneCode}${phoneData.phoneNumber}",
      );
    }
  }

  @override
  State<AppPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<AppPhoneInput> {
  // Internal state variables
  late final FocusNode phoneFocusNode;
  late final RxString phoneCode;
  late final RxString countryCode;
  late final RxString flag;

  @override
  void initState() {
    super.initState();

    // Initialize internal variables
    phoneFocusNode = FocusNode();
    phoneCode = RxString(widget.initialPhoneCode);
    countryCode = RxString(widget.initialCountryCode);
    flag = RxString(widget.initialFlag);

    // If initial phone number is provided, parse it
    if (widget.initialPhoneNumber != null &&
        widget.initialPhoneNumber!.isNotEmpty) {
      _parseInitialPhoneNumber();
    }
  }

  Future<void> _parseInitialPhoneNumber() async {
    await AppPhoneInput.parsePhoneNumber(
      widget.initialPhoneNumber!,
      widget.controller,
      phoneCode,
      countryCode,
    );

    // Update flag based on country code
    try {
      final country = await getCountryByCode(countryCode.value);
      if (country != null) {
        flag.value = country.flagEmoji;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting country flag: $e');
      }
    }
  }

  Future<Country?> getCountryByCode(String code) async {
    try {
      // Get the list of countries from the country_picker package
      final countries = CountryService().getAll();

      // Find the country with matching code
      return countries.firstWhere(
        (country) => country.countryCode.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    super.dispose();
  }

  /// Get current phone data
  PhoneData getCurrentPhoneData() {
    return PhoneData(
      phoneNumber: widget.controller.text,
      phoneCode: phoneCode.value,
      countryCode: countryCode.value,
      flag: flag.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.labelText ?? "",
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: widget.enabled ? Colors.black : Colors.grey,
              ),
            ),
            if (widget.isRequired == true)
              Text(
                " *",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        8.verticalSpace,
        Directionality(
          textDirection: ui.TextDirection.rtl,
          child: TextFormField(
            controller: widget.controller,
            textDirection: ui.TextDirection.ltr,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            keyboardType: TextInputType.phone,
            validator: widget.validator,
            enabled: widget.enabled,
            focusNode: phoneFocusNode,
            onChanged: (value) {
              if (widget.onPhoneChanged != null) {
                widget.onPhoneChanged!(getCurrentPhoneData());
              }
            },

            decoration: InputDecoration(
              hintTextDirection: ui.TextDirection.ltr,
              hintText: widget.hintText ?? 'XXX XXX XXX',
              // labelText: widget.labelText,
              hintStyle: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
              ),
              suffixIcon: IntrinsicHeight(
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppCustomText(
                        text: "  -  ",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      AppCustomText(
                        text: "${phoneCode.value}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      12.horizontalSpace,
                    ],
                  ),
                ),
              ),
              prefixIcon: InkWell(
                onTap:
                    widget.enabled ? () => _showCountryPicker(context) : null,
                child: IntrinsicHeight(
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        12.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24.0.r,
                          color: Colors.black.withOpacity(0.80),
                        ),
                        5.horizontalSpace,
                        AppCustomText(text: flag.value, fontSize: 16.sp),
                      ],
                    ),
                  ),
                ),
              ),
              filled: true,
              isDense: true,
              fillColor: AppTheme.surfaceColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: AppTheme.dividerColor,
                  width: 0.3.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: AppTheme.dividerColor,
                  width: 0.3.w,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 0.3.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: AppTheme.errorColor,
                  width: 0.3.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusTextField,
                ),
                borderSide: BorderSide(
                  color: AppTheme.errorColor,
                  width: 0.3.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showSearch: true,
      useSafeArea: true,
      exclude: ['IL'],
      favorite: ['JO', 'SA', 'AE', 'EG', 'PS'],
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        bottomSheetHeight: ScreenUtil().screenHeight / 1.5,
        textStyle: AppTheme.bodyMedium,
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: 10.h,
          ),
          filled: true,
          fillColor: AppTheme.surfaceColor,
          isDense: true,
          hintText: LangKeys.search.tr,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusTextField),
            borderSide: BorderSide(color: AppTheme.dividerColor, width: 0.3.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusTextField),
            borderSide: BorderSide(color: AppTheme.dividerColor, width: 0.3.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusTextField),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusTextField),
            borderSide: BorderSide(color: AppTheme.errorColor, width: 0.3.w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusTextField),
            borderSide: BorderSide(color: AppTheme.errorColor, width: 0.3.w),
          ),
        ),
      ),
      onSelect: (Country country) {
        phoneCode.value = country.phoneCode;
        countryCode.value = country.countryCode;
        flag.value = country.flagEmoji;

        if (widget.onPhoneChanged != null) {
          widget.onPhoneChanged!(getCurrentPhoneData());
        }
      },
    );
  }

  /// Static methods for utility functions
}

/// Result of phone number validation
class PhoneValidationResult {
  final bool isValid;
  final String formattedNumber; // National format without country code
  final String fullNumber; // International format with country code

  PhoneValidationResult({
    required this.isValid,
    required this.formattedNumber,
    required this.fullNumber,
  });
}

/// Phone data container class
class PhoneData {
  final String phoneNumber; // Without country code
  final String phoneCode; // Country dial code (e.g., "962")
  final String countryCode; // Country code (e.g., "JO")
  final String flag; // Flag emoji

  PhoneData({
    required this.phoneNumber,
    required this.phoneCode,
    required this.countryCode,
    required this.flag,
  });

  // Get the full international phone number
  String get fullNumber => "+$phoneCode$phoneNumber";
}
