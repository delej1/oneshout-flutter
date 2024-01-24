import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photo, this.radius = 48.0}) : super(key: key);

  final String? photo;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    if (photo == null || photo.isEmpty || photo == 'null') {
      return CircleAvatar(
        radius: radius,
        // backgroundImage: photo != null ? NetworkImage(photo) : null,
        child: Icon(Icons.person_outline, size: radius),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: photo,
        fit: BoxFit.cover,
        height: radius * 2,
        width: radius * 2,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
          // width: 60,
          // height: 60,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: imageProvider,
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          child: SizedBox(
            width: radius,
            height: radius,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, dynamic error) => CircleAvatar(
          radius: radius,
          child: Icon(Icons.person_outline, size: radius),
        ),
      );
    }
  }
}

class SquareAvatar extends StatelessWidget {
  const SquareAvatar({
    Key? key,
    this.photo,
    this.size = 48.0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String? photo;
  final double? size;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    if (photo == null || photo.isEmpty || photo == 'null') {
      return ColoredBox(
        color: Colors.grey.shade300,
        child: Icon(
          Icons.person_outline,
          size: size,
          color: Colors.grey.shade500,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: photo,
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, dynamic error) => SizedBox(
          width: size,
          height: size,
          child: Icon(Icons.person_outline, size: size),
        ),
      );
    }
  }
}
