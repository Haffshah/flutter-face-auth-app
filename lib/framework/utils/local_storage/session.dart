import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:face_match/ui/utils/theme/theme.dart';

const String keyAppLanguage = 'keyAppLanguage';
const String keyUserType = 'keyUserType';
const String keyUserAuthToken = 'keyUserAuthToken';
const String keyDeviceFCMToken = 'keyDeviceFCMToken';
const String keyDesignSize = 'keyDesignSize';
const String keyEnableTracking = 'keyEnableTracking';
const String keyEnableTimeInterval = 'keyEnableTimeInterval';
const String keyCurrentTimeInterval = 'keyCurrentTimeInterval';
const String keyEnableDistanceFilter = 'keyEnableDistanceFilter';
const String keyCurrentDistanceFilter = 'keyCurrentDistanceFilter';
const String keyMaxDeliveryLocationCount = 'keyMaxDeliveryLocationCount';

/// Profile Details
const String keyUserData = 'keyUserData';
const String keyUserName = 'keyUserName';
const String keyCompanyType = 'keyCompanyType';
const String keyUserEmail = 'keyUserEmail';
const String keyUserImage = 'keyUserImage';
const String keyUserMobileNo = 'keyUserMobileNo';
const String keyUserId = 'keyUserId';
const String keyUserState = 'keyUserState';
const String keyUserCity = 'keyUserCity';
const String keyUserAddress = 'keyUserAddress';
const String keyUserLatLng = 'keyUserLatLng';
const String keyCurrentUserMember = 'keyCurrentUserMember';

class SessionHelper {
  SessionHelper._();

  static var sessionBox = Hive.box(hiveSessionBox);

  static String get userAccessToken => (sessionBox.get(keyUserAuthToken) ?? '');

  static set userAccessToken(String userAccessToken) => (saveLocalData(keyUserAuthToken, userAccessToken));

  static String getUserType() => (sessionBox.get(keyUserType) ?? '');

  static String get userType => (sessionBox.get(keyUserType) ?? '');

  static set userType(String userType) => (saveLocalData(keyUserType, userType));

  static String get appLanguage => (sessionBox.get(keyAppLanguage) ?? 'en');

  static set appLanguage(String appLanguage) => (saveLocalData(keyAppLanguage, appLanguage));

  static String get deviceFCMToken => (sessionBox.get(keyDeviceFCMToken) ?? '123456');

  static set deviceFCMToken(String deviceFCMToken) => (saveLocalData(keyDeviceFCMToken, deviceFCMToken));

  /// Enable Tracking
  static bool get enableTracking => (sessionBox.get(keyEnableTracking) ?? false);

  static set enableTracking(bool isTracking) => (saveLocalData(keyEnableTracking, isTracking));

  /// Enable Time Interval
  static bool get enableTimeInterval => (sessionBox.get(keyEnableTimeInterval) ?? false);

  static set enableTimeInterval(bool isTracking) => (saveLocalData(keyEnableTimeInterval, isTracking));

  /// Current Time Interval
  static double get currentTimeInterval => (sessionBox.get(keyCurrentTimeInterval) ?? 1);

  static set currentTimeInterval(double interval) => (saveLocalData(keyCurrentTimeInterval, interval));

  /// Enable Distance Filter
  static bool get enableDistanceFilter => (sessionBox.get(keyEnableDistanceFilter) ?? false);

  static set enableDistanceFilter(bool isTracking) => (saveLocalData(keyEnableDistanceFilter, isTracking));

  /// Current Distance Filter
  static double get currentDistanceFilter => (sessionBox.get(keyCurrentDistanceFilter) ?? 2);

  static set currentDistanceFilter(double filterValue) => (saveLocalData(keyCurrentDistanceFilter, filterValue));

  /// Max Delivery Location
  static int get maxDeliveryLocationCount => (sessionBox.get(keyMaxDeliveryLocationCount) ?? 5);

  static set maxDeliveryLocationCount(int filterValue) => (saveLocalData(keyMaxDeliveryLocationCount, filterValue));

  /// User's Data
  static String get getUserData => (sessionBox.get(keyUserData) ?? '');

  static set getUserData(String userData) => (saveLocalData(keyUserData, userData));

  /// User Name
  static String get getUserName => (sessionBox.get(keyUserName) ?? '');

  static set getUserName(String name) => (saveLocalData(keyUserName, name));

  /// Company Type
  static String get getCompanyType => (sessionBox.get(keyCompanyType) ?? '');

  static set getCompanyType(String type) => (saveLocalData(keyCompanyType, type));

  /// User Email
  static String get getUserEmail => (sessionBox.get(keyUserEmail) ?? '');

  static set getUserEmail(String email) => (saveLocalData(keyUserEmail, email));

  /// User Profile Picture
  static String get getUserProfilePic => (sessionBox.get(keyUserImage) ?? commonDummyProfileImage);

  static set getUserProfilePic(String pic) => (saveLocalData(keyUserImage, pic));

  /// User Mobile Number
  static String get getUserMobileNo => (sessionBox.get(keyUserMobileNo) ?? '');

  static set getUserMobileNo(String mobileNo) => (saveLocalData(keyUserMobileNo, mobileNo));

  /// User Id
  static String get getUserId => (sessionBox.get(keyUserId) ?? '');

  static set getUserId(String id) => (saveLocalData(keyUserId, id));

  /// User City
  static String get getUserCity => (sessionBox.get(keyUserCity) ?? '');

  static set getUserCity(String city) => (saveLocalData(keyUserCity, city));

  /// User State
  static String get getUserState => (sessionBox.get(keyUserState) ?? '');

  static set getUserState(String state) => (saveLocalData(keyUserState, state));

  /// User Address
  static String get getUserAddress => (sessionBox.get(keyUserAddress) ?? '');

  static set getUserAddress(String address) => (saveLocalData(keyUserAddress, address));

  /// User LatLng
  static String get getUserLatLng => (sessionBox.get(keyUserLatLng) ?? '');

  static set getUserLatLng(String latLng) => (saveLocalData(keyUserLatLng, latLng));

  /// Is Current User Member
  static int get currentUserMember => (sessionBox.get(keyCurrentUserMember) ?? 0);

  static set currentUserMember(int value) => (saveLocalData(keyCurrentUserMember, value));

  /// Save Local Data
  static void saveLocalData(String key, value) {
    showLog('Saved Local Data $key\n$value');
    sessionBox.put(key, value);
  }

  ///Session Logout
  static Future sessionLogout(WidgetRef ref) async {
    await SessionHelper.sessionBox.clear().then((value) async {
      debugPrint('===========================YOU LOGGED OUT FROM THE APP==============================');

      /// delete DeviceToken api calling
      // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.onboarding());
    });
  }

  static Size get designSize {
    String? size = sessionBox.get(keyDesignSize);
    if (size != null) {
      return Size(double.parse(size.split('+').first), double.parse(size.split('+').last));
    }
    return const Size(1, 1);
  }

  static set designSize(Size designSize) => (sessionBox.put(
    keyDesignSize,
    designSize != const Size(1, 1) ? '${designSize.width}+${designSize.height}' : null,
  ));
}
