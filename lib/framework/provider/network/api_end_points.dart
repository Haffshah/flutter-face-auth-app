class ApiEndPoints {
  /*
  * ----- Api status
  * */
  static const int apiStatus_200 = 200; //success
  static const int apiStatus_201 = 201; //success
  static const int apiStatus_202 = 202; //success for static page
  static const int apiStatus_203 = 203; //success
  static const int apiStatus_205 = 205; // for remaining step 2
  static const int apiStatus_401 = 401; //Invalid data
  static const int apiStatus_404 = 404; //Invalid data
  static const int apiStatus_500 = 500; //Invalid data

  /// Auth
  static String login = 'auth/login';
  static String register = 'auth/register';
  static String registerSocial = 'auth/register-social';
  static String checkUserRegistration = 'auth/check-user-registration';
  static String forgotPassword = 'auth/forgot-password';
  static String verifyOtp = 'auth/verify-otp';
  static String verifyEmail = 'auth/verify-email';
  static String verifyPhone = 'auth/verify-phone';
  static String resetPassword = 'auth/reset-password';
  static String stateList = 'utility/states?code=in';

  static String cityList(String stateCode) => 'utility/cities?state=$stateCode';

  static String citySearch(String city) => 'utility/cities?all=1&city=$city';

  /// Profile
  static String getProfile = 'user/profile';
  static String updateProfile = 'user/profile';
  static String changePassword = 'user/change-password';
  static String deleteAccount = 'user/delete-account';
  static String logout = 'user/logout';

  /// Contact us
  static String contactUs = 'utility/contact-us';

  /// Members
  static String getAllMembers(int pageNo, String searchStr) => '/members?page=$pageNo&search=$searchStr';

  static String getMember(int memberId) => '/members/$memberId';
  static String createMember = '/members';

  static String updateMember(int memberId) => '/members/$memberId';

  static String deleteMember(int memberId) => '/members/$memberId';

  static String getAllMembersLocation(List<int> membersList) =>
      '/members/get-all?${membersList.map((e) => "members[]=${e.toString()}").join('&')}]';

  /// Services
  static String getAllServices({
    required int pageNo,
    required String searchStr,
    required String status,
    required String startDate,
    required String endDate,
  }) =>
      '/services?page=$pageNo&search=$searchStr&status=$status&start_date=$startDate&end_date=$endDate';

  static String getServiceDetails(int serviceId) => '/services/$serviceId';
  static String createService = '/services';

  static String updateService(int serviceId) => '/services/$serviceId';

  static String assignService(int serviceId) => '/services/$serviceId/assign';

  static String deleteMedia(int serviceId) => '/services/$serviceId/update-files';

  static String deleteService(int serviceId) => '/services/$serviceId';

  static String updateServiceStatusAdmin(int serviceId) => '/services/$serviceId/update-status';

  /// Member Services
  static String getMemberServices({
    required int pageNo,
    required String searchStr,
    required String status,
    required String startDate,
    required String endDate,
  }) =>
      '/member-services?page=$pageNo&search=$searchStr&status=$status&start_date=$startDate&end_date=$endDate';

  static String getMemberServiceDetails(int serviceId) => '/member-services/$serviceId';

  static String updateServiceStatus(int serviceId) => '/member-services/$serviceId';

  /// Update Location
  static String setMemberLocation() => '/member-services/update-location';

  static String getMemberLocation(int memberId) => '/services/$memberId/member-location';

  /// Ongoing Deliveries
  static String ongoingDeliveryList({
    required int pageNo,
    required String searchStr,
    required String startDate,
    required String endDate,
  }) =>
      '/deliveries?page=$pageNo&start_date=$startDate&end_date=$endDate&search=$searchStr';

  /// Get Ongoing Service Details LatLng
  static String getOngoingServiceLatLng({
    required int memberId,
    required String startDate,
    required String endDate,
  }) =>
      '/deliveries/$memberId?start_date=$startDate&end_date=$endDate';

  /// Notifications Module
  static String getNotificationList(int pageNo) => '/notifications?page=$pageNo';

  static String deleteNotification(int notificationId) => '/notifications/$notificationId';
  static String deleteAllNotification = '/notifications/delete-all';

  /// Tracking Settings
  static String getOrganizationSettings = '/organization/settings';
  static String setOrganizationSettings = '/organization/settings';

  /// Export Api
  static String exportReport({
    required String startDate,
    required String endDate,
    required String status,
  }) =>
      '/services/export?start_date=$startDate&end_date=$endDate&status=$status';

  ///----------------------------Customer Module Api----------------------------------///
  static String addCustomer = '/customers';

  static String editCustomer(int customerId) => '/customers/$customerId';

  static String getAllCustomer({required int page, required String searchParam}) =>
      '/customers?search=$searchParam&page=$page';

  static String getCustomer(int customerId) => '/customers/$customerId';

  static String deleteCustomer(int customerId) => '/customers/$customerId';
  static String sampleCustomerImportFile = '/customers/import/template';
  static String customerImport = '/customers/import';

  /// Service Timer
  static String getServiceTimes(int serviceId) => '/member-services/get-tracking/$serviceId';

  static String setServiceTimes(int serviceId) => '/member-services/update-tracking/$serviceId';
}
