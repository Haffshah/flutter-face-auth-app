import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

/// Common Keys
const String development = 'development';
const String production = 'production';
const String appName = 'face_match';
const String hiveSessionBox = 'SessionBox';
const String commonDummyProfileImage = 'https://www.cgg.gov.in/wp-content/uploads/2017/10/dummy-profile-pic-male1.jpg';
const String businessTypeService = 'Service';
const String businessTypeDelivery = 'Delivery';
const String serviceTypeService = 'service';
const String serviceTypeDelivery = 'delivery';
const String tabHome = 'Home';
const String tabProfile = 'Profile';
const String statusPending = 'Pending';
const String statusOngoing = 'Ongoing';
const String statusCompleted = 'Completed';
const String statusCancelled = 'Cancelled';
const String dateFormatddMMMyyyy = 'dd MMM yyyy';
const String priorityHigh = 'high';
const String priorityMedium = 'medium';
const String priorityLow = 'low';

/// Get Current Device type
String getCurrentDeviceType() => getIsIOSPlatform() ? 'ios' : 'android';

///-- Date Convert---
String generateFileName() {
  return DateFormat('yyyy_MM_dd_HH_mm_ss_SSS').format(DateTime.now());
}


WidgetRef? globalRef;

bool getIsIOSPlatform() => Platform.isIOS;

DateTime appStartDateTime = DateTime(2022);

bool getIsAppleSignInSupport() => (iosVersion >= 13);
int iosVersion = 11;
int minPasswordLength = 8;
int maxPasswordLength = 16;
int otpLength = 6;
int minMobileLength = 8;
int maxMobileLength = 15;
double minMapZoom = 4;
double midMapZoom = 20;
double maxMapZoom = 30;
int locationUpdateTimeInterval = 5;
int latLngDecimalPlaces = 4;

/// Distance Constants
int popupDistanceInMeters = 100;
int updateProgressDistanceInMeters = 10;

/// Currency
String currency = '₹';
String phoneCode = '+91';

///Page Size in Pagination
int pageSize = 15;
int pageSizeHundred = 100;
int pageSizeThousand = 1000;

String getDeviceType() => getIsIOSPlatform() ? 'iphone' : 'android';

/// Hide Keyboard
void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String dateFormatFromDateTime(DateTime? dateTime, String format) {
  if (dateTime != null) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  } else {
    return '';
  }
}

void commonSnackBar(BuildContext context, String message) {
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(left: context.width * 0.1, right: context.width * 0.1, bottom: context.height * 0.07),
    backgroundColor: AppColors.transparent,
    elevation: 0,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(5.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.regular.copyWith(color: AppColors.white, fontSize: 22.sp),
                ).paddingOnly(right: 30.w),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Icon(Icons.close, color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// To format date and time fromMillisecondsSinceEpoch to {dd MMM yyyy \'at\' h:mma} as per the docs
String formatDatetime({required int createdAt, String? dateFormat}) {
  final DateFormat format = DateFormat(dateFormat ?? 'dd MMM yyyy \'at\' h:mma');
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
  final String formattedString = format.format(dateTime);
  return formattedString;
}

/// Printing Statement
void showLog(String str) {
  debugPrint('=> $str', wrapWidth: 500);
}

/// Make Phone Call
Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

/// Open Email Inbox
Future<void> openEmail(String email) async {
  final Uri launchUri = Uri(scheme: 'mailto', path: email);
  await launchUrl(launchUri);
}

/// Common DatePicker
Future<DateTime?> datePicker(BuildContext context, {String? selectedDate}) async {
  try {
    DateFormat format = DateFormat('MM-dd-yyyy');
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? format.parse(selectedDate) : DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      return pickedDate;
    }
  } catch (e) {
    showLog('Error $e');
  }
  return null;
}

/// Show Common Toast Message
Future<bool?> commonToaster(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.black,
    textColor: AppColors.primary,
    fontSize: 16.0,
  );
}
