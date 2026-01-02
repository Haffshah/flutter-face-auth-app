import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:face_match/ui/utils/helper/base_widget.dart';
import 'package:face_match/ui/utils/theme/app_colors.dart';
import 'package:face_match/ui/utils/theme/assets.gen.dart';

class CacheImage extends StatelessWidget with BaseStatelessWidget {
  final String imageURL;
  final double? height;
  final double? width;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final bool? setPlaceHolder;
  final String? placeholderImage;
  final BoxFit? boxFit;
  final BoxShape? shape;

  const CacheImage({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.setPlaceHolder = true,
    this.placeholderImage,
    this.boxFit,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.topLeftRadius,
    this.topRightRadius,
    this.shape,
  });

  String _getValidImageUrl(String url) {
    if (url.isEmpty) return '';

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme) return '';
      return url;
    } catch (e) {
      return '';
    }
  }

  BorderRadius get _borderRadius => BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius ?? 0.0),
        topRight: Radius.circular(topRightRadius ?? 0.0),
        bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
        bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0),
      );

  @override
  Widget buildPage(BuildContext context) {
    final validUrl = _getValidImageUrl(imageURL);

    if (validUrl.isEmpty) {
      return placeHolderWidget();
    }

    return CachedNetworkImage(
      imageUrl: validUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          shape: shape ?? BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit ?? BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => placeHolderWidget(),
      errorWidget: (context, url, error) => placeHolderWidget(),
    );
  }

  // Widget _loadingWidget() {
  //   return Container(
  //     height: height,
  //     width: width,
  //     decoration: BoxDecoration(
  //       borderRadius: _borderRadius,
  //       color: Colors.grey.withAlpha(51),
  //     ),
  //     child: const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }

  Widget placeHolderWidget() {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          border: Border.all(color: AppColors.grey.withAlpha(50)),
        ),
        child: Center(
          child: Image.asset(
            Assets.images.imagePlaceholder.path,
            height: height,
            width: width,
            fit: boxFit ?? BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
