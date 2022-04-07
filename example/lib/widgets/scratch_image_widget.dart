import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg_example/widgets/svg_image_widget.dart';

/// Created by shiyucheng on 2022/3/10
/// Scratch图片加载组件

class ScratchImage extends StatelessWidget {
  final String data;
  final double height;
  final double width;

  ScratchImage({Key? key, required this.data, this.height = 0, this.width = 0})
      : assert(data.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSvg = data.startsWith("data:image/svg+xml;");
    int subIndex = data.indexOf(",") + 1;
    String base64ImageData = data.substring(subIndex);
    if (isSvg) {
      String rawImageData = String.fromCharCodes(base64Decode(base64ImageData));
      // return SvgPicture.string(rawImageData,width: width,height: height,);
      return SvgImage(svgStr: rawImageData, width: width, height: height);
    } else {
      return Image.memory(base64Decode(base64ImageData),
          height: height, width: width);
    }
  }
}
