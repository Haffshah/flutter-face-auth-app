import 'dart:async';

import 'package:face_match/framework/controller/user/user_list_controller.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_appbar.dart';
import 'package:face_match/ui/utils/widgets/common_card.dart';
import 'package:face_match/ui/utils/widgets/common_dialogs.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:face_match/ui/utils/widgets/empty_state_widget.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(userListControllerProvider).loadUsers();
    });
  }

  Future<bool> _confirmDelete(BuildContext context, String userName) async {
    final completer = Completer<bool>();

    await showConfirmationDialog(
      context,
      'Delete User',
      'Are you sure you want to delete "$userName"? This action cannot be undone.',
      'Delete',
      'Cancel',
      (isPositive) {
        completer.complete(isPositive);
      },
    );

    return completer.future;
  }

  @override
  Widget buildPage(BuildContext context) {
    final controller = ref.watch(userListControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: LocaleKeys.keyRegisteredUsers.localized,
        isLeadingEnable: false,
        centerTitle: true,
        titleTextStyle: TextStyles.bold.copyWith(fontSize: 20.sp, color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.face, color: AppColors.primary, size: 28.sp),
            onPressed: () {
              controller.navigateToFaceScan(ref);
            },
            tooltip: LocaleKeys.keyFaceScanMatch.localized,
          ).paddingOnly(right: 8.w),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.navigateToRegistration(ref);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: CommonText(
          title: LocaleKeys.keyAddUser.localized,
          textStyle: TextStyles.semiBold.copyWith(fontSize: 14.sp, color: AppColors.white),
        ),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3))
          : controller.users.isEmpty
          ? SizedBox(
              height: context.height * 0.8,
              child: EmptyStateWidget(
                title: LocaleKeys.keyNoUsersYet.localized,
                description: LocaleKeys.keyStartByRegisteringYourFirstUser.localized,
              ),
            )
          : ListView.separated(
              itemCount: controller.users.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              padding: EdgeInsets.all(16.w),
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return Dismissible(
                  key: Key('user_${user.id}'),
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16.r)),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: AppColors.white, size: 28.sp),
                        SizedBox(height: 4.h),
                        CommonText(
                          title: LocaleKeys.keyEdit.localized,
                          textStyle: TextStyles.semiBold.copyWith(fontSize: 12.sp, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(16.r)),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: AppColors.white, size: 28.sp),
                        SizedBox(height: 4.h),
                        CommonText(
                          title: LocaleKeys.keyDelete.localized,
                          textStyle: TextStyles.semiBold.copyWith(fontSize: 12.sp, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Left swipe - Delete
                      return await _confirmDelete(context, user.name);
                    } else if (direction == DismissDirection.startToEnd) {
                      // Right swipe - Edit
                      controller.editUser(ref, user);
                      return false; // Don't dismiss, just trigger edit
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      /// Delete confirmed
                      controller.deleteUser(user.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${user.name} deleted'),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      );
                    }
                  },
                  child: CommonCard(
                    elevation: 2,
                    cornerRadius: 16.r,
                    shadowColor: AppColors.textSecondary.withAlpha(51),
                    color: AppColors.backgroundCard,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          /// User Image
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withAlpha(77), width: 2.w),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(26),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CommonImage(
                                strIcon: user.imagePath,
                                isFileImage: !user.imagePath.startsWith('http'),
                                height: 60.h,
                                width: 60.h,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),

                          /// User Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  title: user.name,
                                  textStyle: TextStyles.bold.copyWith(fontSize: 16.sp, color: AppColors.textPrimary),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4.h),
                                CommonText(
                                  title: 'User ID: ${user.id}',
                                  textStyle: TextStyles.regular.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),

                          /// Status Indicator
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_user, size: 14.sp, color: AppColors.primary),
                                SizedBox(width: 4.w),
                                CommonText(
                                  title: LocaleKeys.keyActive.localized,
                                  textStyle: TextStyles.medium.copyWith(fontSize: 11.sp, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
