import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Created by shiyucheng on 2022/3/10
class SvgImage extends StatefulWidget {
  final String svgStr;

  final double height;

  final double width;

  SvgImage({Key? key, required this.svgStr, this.height = 50, this.width = 50})
      : assert(svgStr.trim().isNotEmpty),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SvgImageState();
}

class _SvgImageState extends State<SvgImage> {
  DrawableRoot? _svgDrawable;

  @override
  void initState() {
    super.initState();
    getDrawable();
  }

  Future getDrawable() async {
    _svgDrawable = await svg.fromSvgString(widget.svgStr, "svg_key");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SVGPainter? painter;
    Size size = Size(widget.width, widget.height);
    if (_svgDrawable != null) {
      painter = SVGPainter(_svgDrawable!, size);
    } else {
      null;
    }
    return CustomPaint(
      size: size,
      foregroundPainter: painter,
    );
  }
}

class SVGPainter extends CustomPainter {
  final DrawableRoot _svgDrawable;

  final Size _rawSize;

  SVGPainter(this._svgDrawable, this._rawSize);

  @override
  void paint(Canvas canvas, Size size) {
    // var angle = 45 * pi/180;
    // Matrix4 matrix4 = Matrix4.identity();
    print("raw size is $_rawSize");
    print("size is $size");
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.red);
    // canvas.save();
    // // canvas.translate(-size.width/2, -size.height/2);
    // // matrix4.rotateZ(angle);
    // matrix4.translate(-size.width/2.0, -size.height/2);
    // matrix4.rotateZ(angle);
    // canvas.translate(size.width/2, size.height/2);
    // canvas.transform(matrix4.storage);
    //
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.yellow);
    // canvas.restore();

    // canvas.rotate(angle);
    var picture = _svgDrawable.toPicture(size:_rawSize,clipToViewBox:true);
    canvas.drawPicture(picture);
    // var pictureRecord = PictureRecorder();
    // Canvas pictureCanvas = Canvas(pictureRecord,Offset.zero&size);
    // // pictureCanvas.drawRect(Rect.fromLTWH(size.width/4, size.height/4 * 1, size.width/4 * 3, size.height/4 * 3), Paint()..color = Colors.white);
    // pictureCanvas.drawRect(Offset.zero&Size(size.width/2, size.width/2), Paint()..color = Colors.white);
    // canvas.drawPicture(pictureRecord.endRecording());
    // _draw(canvas, size);
  }

  void _draw(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.red);
    canvas.save();
    var a = 45 * pi / 180;
    final Matrix4 rotate =
        affineMatrix(cos(a), sin(a), -sin(a), cos(a), 0.0, 0.0);
    final double x = size.width / 2.0;
    final double y = size.height / 2.0;
    var finalMatrix = affineMatrix(1.0, 0.0, 0.0, 1.0, x, y)
        .multiplied(rotate)
        .multiplied(affineMatrix(1.0, 0.0, 0.0, 1.0, -x, -y));
    canvas.transform(finalMatrix.storage);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.yellow);
    canvas.restore();
  }

  Matrix4 affineMatrix(
      double a, double b, double c, double d, double e, double f) {
    return Matrix4(
        a, b, 0.0, 0.0, c, d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, e, f, 0.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
