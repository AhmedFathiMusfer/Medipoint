// import 'package:diagno_bot/core/theming/color.dart';
// import 'package:flutter/material.dart';

// class SimpleButton extends StatelessWidget {
//   final String text;
//   bool isLoading = false;
//   final VoidCallback onPressed;

//   SimpleButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         if (!isLoading) {
//           onPressed();
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 6),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         minimumSize: Size(double.infinity, 50),
//         backgroundColor: ColorManager.primaryColor,
//       ),
//       child:
//           isLoading
//               ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.5,
//                 ),
//               )
//               : Text(text, style: TextStyle(color: Colors.white)),
//     );
//   }
// }
// import 'package:diagno_bot/core/theming/color.dart';
// import 'package:flutter/material.dart';

// class SimpleButton extends StatelessWidget {
//   final String text;
//   final bool isLoading;
//   final VoidCallback onPressed;

//   const SimpleButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : onPressed,
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         minimumSize: const Size(double.infinity, 50),
//         backgroundColor: ColorManager.primaryColor,
//       ),
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         switchInCurve: Curves.easeInOut,
//         switchOutCurve: Curves.easeInOut,
//         transitionBuilder: (child, animation) {
//           // Scale + Fade Animation
//           return ScaleTransition(
//             scale: animation,
//             child: FadeTransition(opacity: animation, child: child),
//           );
//         },
//         child:
//             isLoading
//                 ? const SizedBox(
//                   key: ValueKey('loading'),
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2.5,
//                   ),
//                 )
//                 : Text(
//                   text,
//                   key: const ValueKey('text'),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const SimpleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<SimpleButton> createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: ColorManager.primaryColor,
          ),
          child:
              widget.isLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}
