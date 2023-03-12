import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcon {
  static Future<BitmapDescriptor> svgAsset({
    required String assetName,
    required BuildContext context,
    required double size,
  }) async {
    final mediaQuery = MediaQuery.of(context);
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot =
        await svg.fromSvgString(svgString, svgString);
    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    double devicePixelRatio = mediaQuery.devicePixelRatio;
    double width =
        size * devicePixelRatio; // where 32 is your SVG's original width
    double height = size * devicePixelRatio; // same thing
    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> pictureAsset({
    required String assetPath,
    required double width,
    required double height,
  }) async {
    ByteData imageFile = await rootBundle.load(assetPath);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        image: imageFI.image);

    final image = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), (height).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> pictureAssetWithCenterText(
      {required String assetPath,
      required String text,
      required Size size,
      double fontSize = 15,
      Color fontColor = Colors.black,
      FontWeight fontWeight = FontWeight.w500}) async {
    ByteData imageFile = await rootBundle.load(assetPath);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Path clipPath = Path();
    final Radius radius = Radius.circular(size.width / 2);
    clipPath.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    );
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    canvas.clipPath(clipPath);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        canvas: canvas,
        rect:
            Rect.fromLTWH(0, 0, size.width.toDouble(), size.height.toDouble()),
        image: imageFI.image);
    painter.layout();
    painter.paint(
        canvas,
        Offset((size.width * 0.5) - painter.width * 0.5,
            (size.height * .5) - painter.height * 0.5));

    final image = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), (size.height).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> circleCanvasWithText({
    required Size size,
    required String text,
    double fontSize = 15.0,
    Color circleColor = Colors.red,
    Color fontColor = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = circleColor;
    final Radius radius = Radius.circular(size.width / 2);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((size.width * 0.5) - painter.width * 0.5,
            (size.height * .5) - painter.height * 0.5));

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> downloadResizePicture(
      {required String url, int imageSize = 50}) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(url);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, imageSize.toDouble(), imageSize.toDouble()),
        image: imageFI.image);
    final image = await pictureRecorder
        .endRecording()
        .toImage(imageSize, (imageSize * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> fromSvgUrl(
      BuildContext context, String svgCode) async {
    // var dio = Dio();
    // Response response = await dio.get(url);
    //
    // print("reponse" + response.data);
    //
    // RegExp exp = RegExp(
    //     r"<\/?svg(\s|\S)*?>",
    //     multiLine: true,
    //     caseSensitive: true
    // );
    //
    // RegExp exp2 = RegExp(
    //     r"<style(\s|\S)*?<\/style>",
    //     multiLine: true,
    //     caseSensitive: true
    // );

    // String carSvg = response.data.replaceAll(exp, '').replaceAll(exp2, '');

    // print("network svg" + carSvg);

    // String circleSvg1 = '''<path opacity="0.498" d="M45 90C69.8528 90 90 69.8528 90 45C90 20.1472 69.8528 0 45 0C20.1472 0 0 20.1472 0 45C0 69.8528 20.1472 90 45 90Z" fill="#8747F9"/>''';
    // String circleSvg2 = '''<path d="M45 82C65.4345 82 82 65.4345 82 45C82 24.5655 65.4345 8 45 8C24.5655 8 8 24.5655 8 45C8 65.4345 24.5655 82 45 82Z" fill="#8747F9"/>''';

    // String svgStrings='''<svg width="90" height="90" viewBox="0 0 90 90" fill="none" xmlns="http://www.w3.org/2000/svg">
    // $carSvg
    // $circleSvg1
    // $circleSvg2
    // <g>
    // <rect x="22.478" y="56.251" width="30" height="14" rx="5" transform="rotate(32.5804 22.478 56.251)" fill="#ECECED"/>
    // <text x="24" y="66" transform="rotate(32.5804 22.478 56.251)" font-size="10px" fill="#000000">$text</text>
    // </g>
    // </svg>
    // ''';

    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgCode, '');

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        110 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 85 * devicePixelRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> downloadResizePictureCircle(
    String imageUrl, {
    int size = 150,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10,
  }) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(imageUrl);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;

    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(100)));
    /* clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
        Radius.circular(100))); */
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint.color = borderColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    //convert canvas as PNG bytes
    final image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> widgetToIcon(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}
