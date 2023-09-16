import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /*var paint = Paint();// Change this to fill
    var path = Path();
    paint..shader = LinearGradient(
      colors: MyColors.primaryGradient,
    ).createShader(Rect.fromLTWH(0.0, 50.0, 100.0, 50.0));
    paint.style = PaintingStyle.fill;
    path = Path();
    path.moveTo(size.width*0.9, 35);
    path.quadraticBezierTo(size.width * 0.87, size.height * 0.02+35,
        size.width *0.82, size.height*0.02+35);

    path.quadraticBezierTo(size.width * 0.4, size.height * 0.02+35,
        size.width * 0.1, size.height * 0.2+35);

    path.quadraticBezierTo(size.width * 0.04, size.height * 0.25+35,
        size.width * 0.04, size.height*0.35+35);

    path.quadraticBezierTo(size.width * 0.03, size.height * 0.365+35,
        0, size.height*0.37+35 );
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);

    paint = Paint();
    paint..shader = LinearGradient(
      colors: MyColors.primaryGradient,
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 80.0));
    paint.style = PaintingStyle.fill;
    path = Path();
    path.moveTo(size.width*0.1, size.height);
    path.quadraticBezierTo(size.width * 0.13, size.height * 0.98,
        size.width *0.18, size.height*0.98);

    path.quadraticBezierTo(size.width * 0.6, size.height * 0.98,
      size.width * 0.88, size.height * 0.8);

    path.quadraticBezierTo(size.width * 0.96, size.height * 0.75,
        size.width * 0.96, size.height*0.65);

    path.quadraticBezierTo(size.width * 0.97, size.height * 0.635,
        size.width *1, size.height*0.63 );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);

     */
    // var paint = Paint();
    // paint..shader = LinearGradient(
    //   colors: MyColors.primaryGradient
    // ).createShader(Rect.fromLTRB(0,0,size.width,100));
    // paint.style = PaintingStyle.fill; // Change this to fill
    //
    // var path = Path();
    // path.moveTo(size.width+5, size.height * 0.0833);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.125,
    //     size.width * 0.5, size.height * 0.0833);
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.0416,
    //     -5, size.height * 0.0833);
    // path.lineTo(-5, -5);
    // path.lineTo(size.width, -5);
    // canvas.drawPath(path, paint);
    // canvas.drawShadow(path, Colors.grey[500], 2, false);

    var pathWhite = Path();
    pathWhite.moveTo(0, 0);
    pathWhite.lineTo(size.width, 0);
    pathWhite.lineTo(size.width, size.height);
    pathWhite.lineTo(0, size.height);
    canvas.drawPath(pathWhite, Paint()..color = Colors.white);

    var path2 = Path();
    path2.moveTo(size.width * 0.9 + 20, 0);
    path2.quadraticBezierTo(size.width * 0.8 + 20, size.height * 0.05,
        size.width * 0.5 + 20, size.height * 0.05);
    path2.quadraticBezierTo(
        size.width * 0.2 + 20, size.height * 0.05, 0, size.height * 0.25 + 20);
    path2.lineTo(0, 0);
    path2.lineTo(size.width, 0);
    canvas.drawPath(path2, Paint()..color = const Color(0XFFFBC6B0));

    var paint = Paint();
    paint.shader = LinearGradient(
      colors: GlobalTheme.primaryGradient,
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 80.0));
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width * 0.9, 0);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.05,
        size.width * 0.5, size.height * 0.05);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.05, 0, size.height * 0.25);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);

    var path3 = Path();
    path3.moveTo(size.width * 0.1 - 20, size.height);
    path3.quadraticBezierTo(size.width * 0.2 - 20, size.height * 0.95,
        size.width * 0.5 - 20, size.height * 0.95);
    path3.quadraticBezierTo(size.width * 0.8 - 20, size.height * 0.95,
        size.width * 1, size.height * 0.75 - 20);
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    canvas.drawPath(path3, Paint()..color = const Color(0XFFD8F1FB));

    var paint1 = Paint();
    paint1.shader = LinearGradient(
      colors: GlobalTheme.primaryGradient2,
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 80.0));
    paint1.style = PaintingStyle.fill;
    var path1 = Path();
    path1.moveTo(size.width * 0.1, size.height);
    path1.quadraticBezierTo(size.width * 0.2, size.height * 0.95,
        size.width * 0.5, size.height * 0.95);
    path1.quadraticBezierTo(size.width * 0.8, size.height * 0.95,
        size.width * 1, size.height * 0.75);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    canvas.drawPath(path1, paint1);

    // var paint1 = Paint();
    // paint1..shader = LinearGradient(
    //   colors: [Colors.lightBlueAccent,Colors.blueAccent],
    // ).createShader(Rect.fromLTWH(0,0,200,80));
    // paint1.style = PaintingStyle.fill;
    // var path1=Path();
    // path1.moveTo(0, size.height * 0.9167);
    // path1.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
    //     size.width * 0.5, size.height * 0.9167);
    // path1.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
    //     size.width * 1.0, size.height * 0.9167);
    // path1.lineTo(size.width, size.height);
    // path1.lineTo(0, size.height);
    // canvas.drawPath(path1, paint1);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'login',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
