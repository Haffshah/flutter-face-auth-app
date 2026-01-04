import 'package:face_match/framework/controller/user/user_registration_controller.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/models/user_entity.dart';
import 'package:face_match/ui/utils/theme/theme.dart';
import 'package:face_match/ui/utils/widgets/common_appbar.dart';
import 'package:face_match/ui/utils/widgets/common_button.dart';
import 'package:face_match/ui/utils/widgets/common_card.dart';
import 'package:face_match/ui/utils/widgets/common_form_field.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:face_match/framework/controller/user/user_list_controller.dart';
import 'package:face_match/framework/repository/user/contract/user_repository.dart';
import 'package:face_match/ui/routing/stack.dart';
import 'package:face_match/ui/utils/widgets/common_image.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';

final userRegistrationControllerProvider = ChangeNotifierProvider.autoDispose<UserRegistrationController>(
  (ref) => getIt<UserRegistrationController>(),
);
final userRepositoryProvider = Provider<UserRepository>((ref) => getIt<UserRepository>());

class UserRegistrationScreen extends ConsumerStatefulWidget {
  final UserEntity? user;

  const UserRegistrationScreen({super.key, this.user});

  @override
  ConsumerState<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends ConsumerState<UserRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Prefill name if editing
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userRegistrationControllerProvider).init(user: widget.user);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withAlpha(77),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 24.h),

              CommonText(
                title: LocaleKeys.keySelectImageSource.localized,
                textStyle: TextStyles.bold.copyWith(fontSize: 18.sp, color: AppColors.textPrimary),
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt,
                      label: LocaleKeys.keyCamera.localized,
                      onTap: () {
                        Navigator.pop(context);
                        _captureFromCamera();
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library,
                      label: LocaleKeys.keyGallery.localized,
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromGallery();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: CommonCard(
        elevation: 2,
        cornerRadius: 16.r,
        color: AppColors.backgroundCard,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), shape: BoxShape.circle),
                child: Icon(icon, size: 32.sp, color: AppColors.primary),
              ),
              SizedBox(height: 12.h),
              CommonText(
                title: label,
                textStyle: TextStyles.semiBold.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureFromCamera() async {
    final controller = ref.read(userRegistrationControllerProvider);
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a name first', true);
      return;
    }

    FocusScope.of(context).unfocus();
    controller.onCaptureInfo(ref, _nameController.text.trim(), _showSnackBar);
  }

  Future<void> _pickFromGallery() async {
    final controller = ref.read(userRegistrationControllerProvider);
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a name first', true);
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (image != null) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      controller.onGalleryImageSelected(ref, _nameController.text.trim(), image.path, _showSnackBar);
    }
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userRegistrationControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: widget.user != null ? 'Edit User' : 'Register User',
        centerTitle: true,
        titleTextStyle: TextStyles.bold.copyWith(fontSize: 20.sp, color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),

              // Illustration Card
              widget.user != null
                  ? // Edit mode - show current photo
                    CommonCard(
                      elevation: 4,
                      cornerRadius: 20.r,
                      color: AppColors.backgroundCard,
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          children: [
                            ClipOval(
                              child: CommonImage(
                                strIcon: widget.user!.imagePath,
                                isFileImage: !widget.user!.imagePath.startsWith('http'),
                                height: 120.h,
                                width: 120.h,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            CommonText(
                              title: LocaleKeys.keyCurrentPhoto.localized,
                              textStyle: TextStyles.bold.copyWith(fontSize: 18.sp, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 8.h),
                            CommonText(
                              title: LocaleKeys.keyUpdateNameOrCaptureNewPhoto.localized,
                              textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    )
                  : // Create mode - show illustration
                    CommonCard(
                      elevation: 4,
                      cornerRadius: 20.r,
                      color: AppColors.primary.withAlpha(13),
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundCard,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(51),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.face_retouching_natural, size: 80.sp, color: AppColors.primary),
                            ),
                            SizedBox(height: 20.h),
                            CommonText(
                              title: LocaleKeys.keyRegisterNewUser.localized,
                              textStyle: TextStyles.bold.copyWith(fontSize: 20.sp, color: AppColors.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            CommonText(
                              title: LocaleKeys.keyEnterUserDetailsAndCaptureFaceImage.localized,
                              textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

              SizedBox(height: 32.h),

              SizedBox(height: 8.h),
              CommonInputFormField(
                textEditingController: _nameController,
                labelText: LocaleKeys.keyFullName.localized,
                hintText: LocaleKeys.keyEnterFullName.localized,
                prefixWidget: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20.sp),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.keyPleaseEnterAName.localized;
                  }
                  if (value.trim().length < 2) {
                    return LocaleKeys.keyNameMustBeAtLeast2Characters.localized;
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),

              // Status Card
              if (!controller.isInitialized)
                CommonCard(
                  elevation: 2,
                  cornerRadius: 12.r,
                  color: AppColors.primary.withAlpha(26),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CommonText(
                            title: LocaleKeys.keyInitializingFaceSdk.localized,
                            textStyle: TextStyles.medium.copyWith(fontSize: 13.sp, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 24.h),

              // Update Name Button (Edit mode only)
              if (widget.user != null) ...[
                CommonButton(
                  buttonText: LocaleKeys.keyUpdateNameOnly.localized,
                  isButtonEnabled: !controller.isProcessing,
                  buttonEnabledColor: AppColors.secondary,
                  buttonDisabledColor: AppColors.textSecondary.withAlpha(128),
                  height: 56.h,
                  leftIcon: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(Icons.edit, color: AppColors.white, size: 20.sp),
                  ),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _updateNameOnly();
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],

              // Capture Button
              CommonButton(
                buttonText: controller.isProcessing
                    ? 'Processing...'
                    : widget.user != null
                    ? 'Update Photo'
                    : 'Capture Face Image',
                isLoading: controller.isProcessing,
                isButtonEnabled: controller.isInitialized && !controller.isProcessing,
                buttonEnabledColor: AppColors.primary,
                buttonDisabledColor: AppColors.textSecondary.withAlpha(128),
                height: 56.h,
                leftIcon: !controller.isProcessing
                    ? Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Icon(Icons.camera_alt, color: AppColors.white, size: 20.sp),
                      )
                    : null,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showImageSourceDialog();
                  }
                },
              ),

              SizedBox(height: 16.h),

              // Info Card
              CommonCard(
                elevation: 1,
                cornerRadius: 12.r,
                color: AppColors.textSecondary.withAlpha(26),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CommonText(
                          title: widget.user != null
                              ? 'Update name only or capture new photo. New photo will replace the current one.'
                              : 'Ensure good lighting and face the camera directly for best results',
                          textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: AppColors.textSecondary),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void _updateNameOnly() {
    if (widget.user == null) return;

    final updatedUser = UserEntity(name: _nameController.text.trim(), imagePath: widget.user!.imagePath);
    updatedUser.id = widget.user!.id;

    ref.read(userRepositoryProvider).saveUser(updatedUser);
    ref.read(navigationStackController).pop();
    ref.read(userListControllerProvider).loadUsers();

    _showSnackBar('Name Updated Successfully!', false);
  }
}
