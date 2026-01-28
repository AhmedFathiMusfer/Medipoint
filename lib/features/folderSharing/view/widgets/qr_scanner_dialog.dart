import 'package:diagno_bot/core/theming/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Dialog to scan a QR code and extract doctor ID
/// Returns the doctorId as a String if successfully scanned
Future<String?> showQRScannerDialog({required BuildContext context}) async {
  return Navigator.push<String>(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const _QRScannerView(),
    ),
  );
}

class _QRScannerView extends StatefulWidget {
  const _QRScannerView();

  @override
  State<_QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<_QRScannerView> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;
  bool _isFlashOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        // Check if the QR code contains a doctor ID
        final String? doctorId = _extractDoctorId(rawValue);
        if (doctorId != null) {
          _hasScanned = true;
          Navigator.pop(context, doctorId);
          return;
        }
      }
    }
  }

  /// Extract doctor ID from QR code value
  /// Supports multiple formats:
  /// 1. Just the doctorId as plain text
  /// 2. JSON format: {"doctorId": "xxx"}
  /// 3. URL format: https://example.com/doctor/xxx
  String? _extractDoctorId(String rawValue) {
    final trimmed = rawValue.trim();

    // 1️⃣ medipoint:user:UUID
    if (trimmed.startsWith('medipoint:user:')) {
      return trimmed.replaceFirst('medipoint:user:', '').trim();
    }

    // 2️⃣ JSON format
    if (trimmed.startsWith('{') && trimmed.contains('doctorId')) {
      final regex = RegExp(r'"doctorId"\s*:\s*"([^"]+)"');
      final match = regex.firstMatch(trimmed);
      if (match != null) {
        return match.group(1);
      }
    }

    // 3️⃣ URL format (e.g., /doctor/xxx)
    if (trimmed.contains('/doctor/')) {
      final parts = trimmed.split('/doctor/');
      if (parts.length > 1) {
        return parts.last.split('/').first.split('?').first;
      }
    }

    // 4️⃣ Query parameter format
    if (trimmed.contains('doctorId=')) {
      final regex = RegExp(r'doctorId=([^&]+)');
      final match = regex.firstMatch(trimmed);
      if (match != null) {
        return match.group(1);
      }
    }

    // 5️⃣ Fallback: extract last part after colon (general case)
    if (trimmed.contains(':')) {
      final parts = trimmed.split(':');
      final last = parts.last.trim();
      if (last.isNotEmpty) {
        return last;
      }
    }

    // 6️⃣ If it's a plain UUID or ID
    if (trimmed.isNotEmpty && !trimmed.contains(' ')) {
      return trimmed;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner
          MobileScanner(controller: controller, onDetect: _onDetect),
          // Overlay
          CustomPaint(
            size: Size.infinite,
            painter: QRScannerOverlayPainter(
              borderColor: ColorManager.primaryColor,
              borderRadius: 16.r,
              borderLength: 40.r,
              borderWidth: 4.r,
              cutOutSize: 280.w,
              overlayColor: const Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),

          // Top bar with close and flash buttons
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  _CircleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  // Flash toggle
                  _CircleButton(
                    icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: () async {
                      await controller.toggleTorch();
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(32.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 48.r,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'scan_doctor_qr'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'scan_doctor_qr_hint'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48.w,
          height: 48.w,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 24.r),
        ),
      ),
    );
  }
}

/// Custom overlay shape for QR scanner
/// Custom overlay shape for QR scanner
class QRScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QRScannerOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.overlayColor,
    required this.borderRadius,
    required this.borderLength,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final borderOffset = borderWidth / 2;

    final backgroundPaint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round;

    final cutOutRect = Rect.fromLTWH(
      (width - cutOutSize) / 2 + borderOffset,
      (height - cutOutSize) / 2 + borderOffset,
      cutOutSize - borderOffset * 2,
      cutOutSize - borderOffset * 2,
    );

    // Overlay + hole
    canvas
      ..saveLayer(Offset.zero & size, Paint())
      ..drawRect(Offset.zero & size, backgroundPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();

    final left = cutOutRect.left;
    final top = cutOutRect.top;
    final right = cutOutRect.right;
    final bottom = cutOutRect.bottom;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(left, top + borderLength)
        ..lineTo(left, top + borderRadius)
        ..quadraticBezierTo(left, top, left + borderRadius, top)
        ..lineTo(left + borderLength, top),
      borderPaint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(right - borderLength, top)
        ..lineTo(right - borderRadius, top)
        ..quadraticBezierTo(right, top, right, top + borderRadius)
        ..lineTo(right, top + borderLength),
      borderPaint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(right, bottom - borderLength)
        ..lineTo(right, bottom - borderRadius)
        ..quadraticBezierTo(right, bottom, right - borderRadius, bottom)
        ..lineTo(right - borderLength, bottom),
      borderPaint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(left + borderLength, bottom)
        ..lineTo(left + borderRadius, bottom)
        ..quadraticBezierTo(left, bottom, left, bottom - borderRadius)
        ..lineTo(left, bottom - borderLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
