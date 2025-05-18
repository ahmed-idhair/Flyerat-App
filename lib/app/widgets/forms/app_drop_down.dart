import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_theme.dart';
import '../../translations/lang_keys.dart';
import 'app_custom_text.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final void Function(T?) onChanged;
  final Future<List<T>> Function(String)? asyncItems;
  final Future<List<T>> Function()? onFind;
  final bool showSearchBox;
  final bool showClearButton;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final bool Function(T, String)? filterFn;
  final String Function(T)? itemAsString;
  final String? errorText;
  final String? hintText;
  final bool isLoading;
  final bool enabled;
  final bool? isRequired;
  final double? maxHeight;
  final TextStyle? labelStyle;
  final InputDecoration? searchDecoration;
  final String? searchHintText;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.asyncItems,
    this.onFind,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.dropdownBuilder,
    this.itemBuilder,
    this.filterFn,
    this.itemAsString,
    this.errorText,
    this.hintText,
    this.isLoading = false,
    this.enabled = true,
    this.maxHeight,
    this.labelStyle,
    this.searchDecoration,
    this.searchHintText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: enabled ? Colors.black : Colors.grey,
              ),
            ),
            if (isRequired == true)
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
        DropdownSearch<T>(
          items: items,
          selectedItem: selectedItem,
          onChanged: onChanged,
          asyncItems: asyncItems,
          dropdownButtonProps: DropdownButtonProps(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
              size: 28.r,
            ),
          ),
          enabled: enabled && !isLoading,
          // Add compareFn here
          compareFn: (item1, item2) => item1 == item2,
          popupProps: PopupProps.menu(
            showSearchBox: showSearchBox,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: LangKeys.search.tr,
                hintStyle: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
                ),
                errorText: errorText,
                filled: true,
                isDense: true,
                fillColor:
                    enabled ? AppTheme.surfaceColor : Colors.grey.shade200,
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

            //   TextFieldProps(
            //   decoration: searchDecoration ??
            //       InputDecoration(
            //         hintText: searchHintText ?? '${LangKeys.search.tr} ${label.toLowerCase()}...',
            //         prefixIcon: const Icon(Icons.search),
            //         border: const OutlineInputBorder(),
            //       ),
            // ),
            showSelectedItems: true,
            itemBuilder:
                itemBuilder ??
                (context, item, isSelected) {
                  return ListTile(
                    selected: isSelected,
                    title: AppCustomText(
                      text: itemAsString?.call(item) ?? item.toString(),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                    ),
                  );
                },
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.4,
            ),
            loadingBuilder:
                (context, searchEntry) =>
                    const Center(child: CircularProgressIndicator()),
            emptyBuilder:
                (context, searchEntry) => Center(
                  child: AppCustomText(
                    text: LangKeys.noData.tr,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            containerBuilder:
                (context, popupWidget) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: popupWidget,
                ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
              ),
              errorText: errorText,
              filled: true,
              isDense: true,
              fillColor: enabled ? AppTheme.surfaceColor : Colors.grey.shade200,
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
          dropdownBuilder: dropdownBuilder,
          filterFn: filterFn,
          itemAsString: itemAsString,
          clearButtonProps: ClearButtonProps(
            isVisible: showClearButton && enabled,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
