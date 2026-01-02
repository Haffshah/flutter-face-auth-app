import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:face_match/ui/utils/theme/theme.dart';

class DialogProgressBar extends StatelessWidget {
  final bool isLoading;
  final bool forPagination;
  final double? height;

  const DialogProgressBar({
    super.key,
    required this.isLoading,
    this.forPagination = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!(isLoading)) {
      return const Offstage();
    } else {
      if ((forPagination)) {
        return SizedBox(
          height: 70.h,
          child: Center(
            child: LoadingAnimationWidget.threeArchedCircle(color: AppColors.primary, size: 40),
          ),
        );
      } else {
        return AbsorbPointer(
          absorbing: true,
          child: Container(
            height: height ?? context.height,
            color: AppColors.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: SizedBox(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
