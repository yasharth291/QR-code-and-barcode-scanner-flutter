import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_barcode.dart';

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.absoluteImageSize, this.barcodeLocations);

  final List<Barcode> barcodeLocations;
  final Size absoluteImageSize;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(Barcode barcode) {
      return Rect.fromLTRB(
        barcode.boundingBox.left * scaleX,
        barcode.boundingBox.top * scaleY,
        barcode.boundingBox.right * scaleX,
        barcode.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (Barcode barcode in barcodeLocations) {
      paint.color = Colors.green;

      canvas.drawRect(scaleRect(barcode), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.barcodeLocations != barcodeLocations;
  }
}
