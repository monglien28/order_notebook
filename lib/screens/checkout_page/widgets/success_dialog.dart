import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order_notebook/main.dart';
import 'package:order_notebook/screens/last_order_page/last_page.dart';

class SuccessDialog {
  static Future<void> show(
    BuildContext ctx,
    int currentOrderCount,
    int totalCount,
  ) async {
    try {
      if (!ctx.mounted) return;

      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (dialogCtx) {
          // Auto dismiss after 5 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (dialogCtx.mounted) {
              Navigator.of(dialogCtx).pop(); // Close dialog
              Navigator.of(dialogCtx).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => AppContainer(
                    child: LastPage(
                      currentOrderCount: currentOrderCount,
                      totalCount: totalCount,
                    ),
                  ),
                ),
                (_) => false,
              );
            }
          });

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Animated Tick Mark
                  Lottie.asset(
                    decoder: LottieComposition.decodeGZip,
                    "assets/animation/success.tgs",
                    width: 150,
                    height: 150,
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Order Placed Successfully!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Order will be delivered within 24 hours.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(dialogCtx).pop(); // Close dialog
                  //     Navigator.of(dialogCtx).pushAndRemoveUntil(
                  //       MaterialPageRoute(
                  //         builder: (_) => AppContainer(
                  //           child: LastPage(
                  //             currentOrderCount: currentOrderCount,
                  //             totalCount: totalCount,
                  //           ),
                  //         ),
                  //       ),
                  //       (_) => false,
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.green,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //     child: Text(
                  //       "OK",
                  //       style: TextStyle(fontSize: 16, color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
