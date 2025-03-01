import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomImageWidget extends StatelessWidget {
  var imageUrl;
  var shortName;
  double? size;
  Color color;
  final double? fontSize;
  CustomImageWidget(
      {Key? key,
      this.imageUrl,
      this.shortName,
      this.size,
      this.fontSize,
      this.color = colorSecondary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return SizedBox(
      height: size ?? 70,
      width: size ?? 70,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}

class CustomSqureImageWidget extends StatelessWidget {
  var imageUrl;
  var shortName;
  double? size;
  CustomSqureImageWidget({Key? key, this.imageUrl, this.shortName, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 70,
      width: size ?? 70,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: appBarColor,
            border: Border.all(color: colorSecondary, width: 1),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorSecondary, width: 1),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: colorSecondary,
          ),
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}

