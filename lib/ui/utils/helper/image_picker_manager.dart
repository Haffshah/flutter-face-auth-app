import 'dart:io';

import 'package:face_match/framework/utils/extension/extension.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/theme/app_colors.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';
import 'package:face_match/ui/utils/theme/text_style.dart';
import 'package:face_match/ui/utils/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/*
Required permissions for iOS
NSCameraUsageDescription :- ${PRODUCT_NAME} is require camera permission to choose user profile photo.
NSPhotoLibraryUsageDescription :- ${PRODUCT_NAME} is require photos permission to choose user profile photo.

Required permissions for Android
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA"/>

<!--Image Cropper-->
       <activity
           android:name="com.yalantis.ucrop.UCropActivity"
           android:exported="true"
           android:screenOrientation="portrait"
           android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
* */

class ImagePickerManager {
  ImagePickerManager._privateConstructor();

  static final ImagePickerManager instance = ImagePickerManager._privateConstructor();

  final ImagePicker picker = ImagePicker();

  // final ImageCropper cropper = ImageCropper();

  var imgSelectOption = {
    LocaleKeys.keyCamera.localized,
    LocaleKeys.keyGallery.localized,
    LocaleKeys.keyVideo.localized,
    LocaleKeys.keyImage.localized,
  };

  /*
  Open Picker
  Usage:- File? file = await ImagePickerManager.instance.openPicker(context);
  * */

  Future<File?> openPicker(
    BuildContext context, {
    String? title,
    double? ratioX,
    double? ratioY,
    // CropStyle? cropStyle,
    Function? onRemoveCallBack,
  }) async {
    await Permission.camera.request();
    String type = '';
    String subType = '';
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.black.withAlpha(30),
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -4),
                      blurRadius: 12.r,
                      spreadRadius: 0,
                      color: AppColors.black.withAlpha(30),
                    ),
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 12.r,
                      spreadRadius: 0,
                      color: AppColors.black.withAlpha(25),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(left: 29.w, right: 29.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Camera
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            // PopupMenuItem(
                            //   onTap: () async {
                            //     subType = LocaleKeys.keyImage.localized;
                            //     final cameraPermission = await Permission.camera.status;
                            //     showLog('cameraPermission $cameraPermission');
                            //     if (cameraPermission == PermissionStatus.granted) {
                            //       type = LocaleKeys.keyCamera.localized;
                            //     } else {
                            //       commonToaster(LocaleKeys.keyCameraPermissionNotGranted.localized);
                            //     }
                            //     Navigator.pop(context);
                            //   },
                            //   child: Text(LocaleKeys.keyImage.localized),
                            // ),
                            // if (onRemoveCallBack == null)
                            //   PopupMenuItem(
                            //     onTap: () async {
                            //       subType = LocaleKeys.keyVideo.localized;
                            //       final cameraPermission = await Permission.camera.status;
                            //       showLog('cameraPermission $cameraPermission');
                            //       if (cameraPermission == PermissionStatus.granted) {
                            //         type = LocaleKeys.keyCamera.localized;
                            //       } else {
                            //         commonToaster(LocaleKeys.keyCameraPermissionNotGranted.localized);
                            //       }
                            //       Navigator.pop(context);
                            //     },
                            //     child: Text(LocaleKeys.keyVideo.localized),
                            //   ),
                          ],
                          child: commonImageTitleWidget(Icons.camera_alt, LocaleKeys.keyCamera.localized, () async {
                            final cameraPermission = await Permission.camera.status;
                            showLog('cameraPermission $cameraPermission');
                            if (cameraPermission == PermissionStatus.granted) {
                              type = LocaleKeys.keyCamera.localized;
                              subType = LocaleKeys.keyImage.localized;
                            } else {
                              commonToaster(LocaleKeys.keyCameraPermissionNotGranted.localized);
                            }
                            Navigator.pop(context);
                          }),
                        ),

                        /// Gallery
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            // PopupMenuItem(
                            //   onTap: () async {
                            //     subType = LocaleKeys.keyImage.localized;
                            //     type = LocaleKeys.keyGallery.localized;
                            //     Navigator.pop(context);
                            //   },
                            //   child: Text(LocaleKeys.keyImage.localized),
                            // ),
                            // if (onRemoveCallBack == null)
                            //   PopupMenuItem(
                            //     onTap: () async {
                            //       subType = LocaleKeys.keyVideo.localized;
                            //       type = LocaleKeys.keyGallery.localized;
                            //       Navigator.pop(context);
                            //     },
                            //     child: Text(LocaleKeys.keyVideo.localized),
                            //   ),
                          ],
                          child: commonImageTitleWidget(Icons.perm_media_outlined, LocaleKeys.keyGallery.localized, () {
                            subType = LocaleKeys.keyImage.localized;
                            type = LocaleKeys.keyGallery.localized;
                            Navigator.pop(context);
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                LocaleKeys.keyCancel.localized,
                                style: TextStyles.semiBold.copyWith(color: AppColors.redLight),
                              ),
                            ),
                          ),
                        ),
                        if (onRemoveCallBack != null) SizedBox(width: 10.w),
                        Visibility(
                          visible: onRemoveCallBack != null,
                          child: Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                onRemoveCallBack?.call();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  LocaleKeys.keyRemove.localized,
                                  style: TextStyles.semiBold.copyWith(color: AppColors.secondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    File? croppedFile;
    if (type.isNotEmpty) {
      /// Document
      // if (LocaleKeys.keyDocument.localized == type) {
      //   FilePickerResult? result = await FilePicker.platform.pickFiles();
      //
      //   if (result != null) {
      //     List<File> files = result.paths.map((path) => File(path!)).toList();
      //     if (files.isNotEmpty) {
      //       croppedFile = files.first;
      //     }
      //   } else {
      //     commonToaster('Canceled by used');
      //   }
      // }

      /// Camera
      if (LocaleKeys.keyCamera.localized == type) {
        XFile? pickedFile = (subType == LocaleKeys.keyImage.localized)
            ? await picker.pickImage(source: ImageSource.camera)
            : await picker.pickVideo(source: ImageSource.camera);

        showLog('pickedFile At Camera: $pickedFile');

        if (pickedFile != null && pickedFile.path != '' && subType == LocaleKeys.keyImage.localized) {
          // CroppedFile? cropImage = (await cropper.cropImage(
          //   sourcePath: pickedFile.path,
          //   aspectRatio: CropAspectRatio(ratioX: ratioX ?? 1, ratioY: ratioY ?? 1),
          // ));

          croppedFile = File(pickedFile.path);
          // if (cropImage != null && cropImage.path != '') {
          //   croppedFile = File(cropImage.path);
          // }
        } else if (pickedFile != null && pickedFile.path != '' && subType == LocaleKeys.keyVideo.localized) {
          croppedFile = File(pickedFile.path);
        }
      } else if (LocaleKeys.keyGallery.localized == type) {
        XFile? pickedFile = (subType == LocaleKeys.keyImage.localized)
            ? await picker.pickImage(source: ImageSource.gallery)
            : await picker.pickVideo(source: ImageSource.gallery);

        showLog('pickedFile At Gallery: $pickedFile');

        if (pickedFile != null && pickedFile.path != '' && subType == LocaleKeys.keyImage.localized) {
          // CroppedFile? cropImage = (await cropper.cropImage(
          //   sourcePath: pickedFile.path,
          // aspectRatio: CropAspectRatio(ratioX: ratioX ?? 1, ratioY: ratioY ?? 1),
          // ));

          // if (cropImage != null && cropImage.path != '') {
          croppedFile = File(pickedFile.path);
          // }
        } else if (pickedFile != null && pickedFile.path != '' && subType == LocaleKeys.keyVideo.localized) {
          croppedFile = File(pickedFile.path);
        }
      }
      showLog('croppedFile $croppedFile');
      return croppedFile;
    } else {}
    return null;
  }

  /// Common Image Title widget
  IgnorePointer commonImageTitleWidget(IconData iconData, String title, Function? onTap) {
    return IgnorePointer(
      ignoring: onTap == null,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap.call();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, size: 40.sp, color: AppColors.primary),
            // CommonImage(
            //   strIcon: image,
            //   height: 40.h,
            //   width: 40.h,
            //   boxFit: BoxFit.scaleDown,
            //   imgColor: AppColors.primary,
            // ),
            CommonText(
              title: title,
              textStyle: TextStyles.regular.copyWith(color: AppColors.primary, fontSize: 13.sp),
            ).paddingOnly(top: 10.h),
          ],
        ),
      ),
    );
  }

  /*
  Open Multi Picker
  Usage:- Future<List<File>?> files = ImagePickerManager.instance.openMultiPicker(context);
  * */
  Future<List<File>?> pickMultipleImages({
    required BuildContext context,
    int maxImages = 4,
    int maxFileSizeInMB = 1,
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: imageQuality ?? 80,
        maxWidth: maxWidth ?? 1024,
        maxHeight: maxHeight ?? 1024,
      );

      if (pickedFiles.isEmpty) return null;

      // Convert XFile to File and apply validations
      List<File> files = [];

      // Check max count
      final imagesToProcess = pickedFiles.length > maxImages ? pickedFiles.sublist(0, maxImages) : pickedFiles;

      for (var pickedFile in imagesToProcess) {
        final file = File(pickedFile.path);

        // Check file size
        final sizeInMb = file.lengthSync() / (1024 * 1024);
        if (sizeInMb > maxFileSizeInMB) {
          _showMessage(context, 'Image size should be less than ${maxFileSizeInMB}MB');
          return null;
        }

        files.add(file);
      }

      return files;
    } catch (e) {
      debugPrint('Error picking images: $e');
      return null;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  ///Handle Document After Picker
  // handleDocumentAfterPicker(BuildContext context, Function(List<File>) resultBlock) async {
  //   List<File> files = [];
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'],);
  //
  //   if(result != null) {
  //     // files = result.paths.map((path) => PickedFile(path ?? "")).toList();
  //     files = result.paths.map((path) => File(path ?? "")).toList();
  //   }
  //   resultBlock(files);
  // }
}
