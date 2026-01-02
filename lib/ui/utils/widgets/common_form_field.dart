import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonInputFormField extends StatelessWidget with BaseStatelessWidget {
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final String? placeholderImage;
  final double? placeholderImageHeight;
  final double? placeholderImageWidth;
  final double? placeholderImageHorizontalPadding;
  final String? placeholderText;
  final TextStyle? placeholderTextStyle;
  final String? hintText;
  final String? suffixText;
  final TextStyle? hintTextStyle;
  final TextStyle? suffixTextStyle;
  final double? fieldHeight;
  final double? fieldWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final TextStyle? fieldTextStyle;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final bool? isEnable;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Widget? suffix;
  final InputDecoration? inputDecoration;
  final bool? obscureText;
  final double? bottomFieldMargin;
  final Function(String text)? onChanged;
  final Widget? suffixLabel;
  final Color? cursorColor;
  final bool? enableInteractiveSelection;
  final bool? readOnly;
  final String? labelText;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorMessage;
  final bool hasLabel;
  final TextAlignVertical? textAlignVertical;
  final bool? hasError;
  final Widget? label;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final AutovalidateMode? autovalidateMode;
  final TextDirection? textDirection;
  final bool autofocus;

  const CommonInputFormField({
    super.key,
    this.textEditingController,
    this.validator,
    this.placeholderImage,
    this.placeholderImageHeight,
    this.placeholderImageWidth,
    this.placeholderImageHorizontalPadding,
    this.placeholderText,
    this.placeholderTextStyle,
    this.hintText,
    this.hintTextStyle,
    this.fieldHeight,
    this.fieldWidth,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fieldTextStyle,
    this.maxLines = 1,
    this.maxLength,
    this.textInputFormatter,
    this.textInputAction,
    this.textInputType,
    this.textCapitalization,
    this.isEnable,
    this.prefixWidget,
    this.suffixWidget,
    this.inputDecoration,
    this.obscureText,
    this.bottomFieldMargin,
    this.onChanged,
    this.suffixLabel,
    this.cursorColor,
    this.enableInteractiveSelection,
    this.readOnly,
    this.onTap,
    this.focusNode,
    this.onFieldSubmitted,
    this.contentPadding,
    this.textAlignVertical,
    this.label,
    this.errorMessage = '',
    this.hasLabel = false,
    this.hasError,
    this.labelText,
    this.autovalidateMode,
    this.suffix,
    this.floatingLabelBehavior,
    this.suffixText,
    this.suffixTextStyle,
    this.textDirection,
    this.autofocus = false,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Opacity(
      opacity: (readOnly ?? false) ? 0.4 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: labelText ?? '',
            textStyle: fieldTextStyle ?? TextStyles.semiBold.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
          ).paddingOnly(bottom: 4.h),
          SizedBox(
            width: fieldWidth ?? double.infinity,
            height: fieldHeight,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomFieldMargin ?? 0),
              child: Directionality(
                textDirection: textDirection ?? TextDirection.ltr,
                child: TextFormField(
                  autofocus: autofocus,
                  textDirection: textDirection,
                  autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
                  onTap: () {
                    focusNode?.requestFocus();
                    onTap?.call();
                  },
                  onFieldSubmitted: onFieldSubmitted,
                  readOnly: readOnly ?? false,
                  cursorColor: cursorColor ?? AppColors.primary,
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: fieldTextStyle ?? TextStyles.regular.copyWith(color: AppColors.textPrimary, fontSize: 14.sp),
                  textAlign: TextAlign.start,
                  textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
                  maxLines: maxLines,
                  maxLength: maxLength ?? 1000,
                  enableInteractiveSelection: enableInteractiveSelection ?? true,
                  obscureText: obscureText ?? false,
                  inputFormatters: textInputFormatter,
                  onChanged: onChanged,
                  textInputAction: textInputAction ?? TextInputAction.next,
                  keyboardType: textInputType ?? TextInputType.text,
                  textCapitalization: textCapitalization ?? TextCapitalization.none,
                  onTapOutside: (a) {
                    hideKeyboard(context);
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    errorMaxLines: 3,
                    enabled: isEnable ?? true,
                    counterText: '',
                    errorStyle: TextStyles.regular.copyWith(color: AppColors.errorColor, fontSize: 13.sp),
                    filled: true,
                    fillColor: backgroundColor ?? AppColors.backgroundCard,
                    suffixIcon: suffixWidget,
                    suffixText: suffixText,
                    suffixStyle: suffixTextStyle,
                    prefixIcon: prefixWidget,
                    contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.borderColor,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.borderColor,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.errorColor,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.borderColor,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.errorColor,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle:
                        hintTextStyle ??
                        TextStyles.regular.copyWith(
                          fontSize: 13.sp,
                          color:
                              ((validator?.call(textEditingController?.text) != null) &&
                                  (textEditingController?.text.isNotEmpty ?? false))
                              ? AppColors.errorColor
                              : AppColors.textSecondary,
                        ),
                    labelText: hasLabel ? hintText : null,
                    suffix: suffix,
                    floatingLabelBehavior: floatingLabelBehavior,
                    alignLabelWithHint: true,
                    labelStyle:
                        hintTextStyle ??
                        TextStyles.regular.copyWith(
                          color:
                              ((validator?.call(textEditingController?.text) != null) &&
                                  (textEditingController?.text.isNotEmpty ?? false))
                              ? AppColors.errorColor
                              : AppColors.textSecondary,
                        ),
                  ),
                  validator: validator,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
Widget Usage

CommonInputFormField(
  textEditingController: _mobileController,
  suffixWidget: Image.asset(Assets.imagesIcApple),
  validator: validateEmail,
  backgroundColor: AppColors.pinch,
  prefixWidget: Image.asset(Assets.imagesIcApple),
  placeholderImage: Assets.imagesIcApple,
  placeholderText: LocaleKeys.keyMobileNumber.localized,
)
*/
