import 'package:face_match/ui/utils/theme/theme.dart';

class ThemeStyle {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: TextStyles.fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBGByTheme(),
      useMaterial3: true,
      hintColor: AppColors.grey,
      primarySwatch: AppColors.colorPrimary,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: AppColors.textByTheme()),
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      cardColor: AppColors.white,
      cardTheme: const CardThemeData(surfaceTintColor: AppColors.white),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.colorPrimary,
      ).copyWith(surface: AppColors.scaffoldBGByTheme()),
    );
  }
}
