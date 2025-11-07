import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kasirsuper/core/core.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  static const String routeName = '/barcode-scanner';

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isScanned) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() {
                    _isScanned = true;
                  });
                  
                  // Return the scanned barcode
                  Navigator.pop(context, barcode.rawValue);
                  return;
                }
              }
            },
          ),
          // Scanner frame overlay
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: context.theme.primaryColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(Dimens.dp16),
              margin: const EdgeInsets.symmetric(horizontal: Dimens.dp24),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.7 * 255).round()),
                borderRadius: BorderRadius.circular(Dimens.dp12),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Arahkan kamera ke barcode produk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

// Custom overlay shape for scanner frame
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.borderLength = 40,
    this.borderRadius = 10,
    required this.cutOutSize,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final bLength =
        borderLength > min(cutOutSize / 2, borderWidthSize) ? borderWidthSize : borderLength;
    final cutOutWidth = cutOutSize < width ? cutOutSize : width - borderOffset;
    final cutOutHeight = cutOutSize < height ? cutOutSize : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = Colors.black.withAlpha((0.5 * 255).round())
      ..style = PaintingStyle.fill;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - cutOutWidth / 2 + borderOffset,
      rect.top + height / 2 - cutOutHeight / 2 + borderOffset,
      cutOutWidth - borderOffset * 2,
      cutOutHeight - borderOffset * 2,
    );

    canvas.saveLayer(
      rect,
      backgroundPaint,
    );
    canvas.drawRect(
      rect,
      backgroundPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cutOutRect,
        Radius.circular(borderRadius),
      ),
      boxPaint..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // Draw corner borders
    final path = Path()
      // Top left
      ..moveTo(cutOutRect.left, cutOutRect.top + bLength)
      ..lineTo(cutOutRect.left, cutOutRect.top + borderRadius)
      ..quadraticBezierTo(cutOutRect.left, cutOutRect.top, cutOutRect.left + borderRadius,
          cutOutRect.top)
      ..lineTo(cutOutRect.left + bLength, cutOutRect.top)
      // Top right
      ..moveTo(cutOutRect.right - bLength, cutOutRect.top)
      ..lineTo(cutOutRect.right - borderRadius, cutOutRect.top)
      ..quadraticBezierTo(cutOutRect.right, cutOutRect.top, cutOutRect.right,
          cutOutRect.top + borderRadius)
      ..lineTo(cutOutRect.right, cutOutRect.top + bLength)
      // Bottom right
      ..moveTo(cutOutRect.right, cutOutRect.bottom - bLength)
      ..lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius)
      ..quadraticBezierTo(cutOutRect.right, cutOutRect.bottom,
          cutOutRect.right - borderRadius, cutOutRect.bottom)
      ..lineTo(cutOutRect.right - bLength, cutOutRect.bottom)
      // Bottom left
      ..moveTo(cutOutRect.left + bLength, cutOutRect.bottom)
      ..lineTo(cutOutRect.left + borderRadius, cutOutRect.bottom)
      ..quadraticBezierTo(cutOutRect.left, cutOutRect.bottom, cutOutRect.left,
          cutOutRect.bottom - borderRadius)
      ..lineTo(cutOutRect.left, cutOutRect.bottom - bLength);

    canvas.drawPath(path, boxPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderLength: borderLength,
      borderRadius: borderRadius,
      cutOutSize: cutOutSize,
    );
  }
}
