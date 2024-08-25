import 'package:flutter/material.dart';

class ShowSnackBarCustom {
  static void showSnackBar(
      BuildContext context, String text, Color color, Icon icon,
      {Duration duration = const Duration(seconds: 2),
      SnackBarBehavior behavior = SnackBarBehavior.floating}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        behavior: behavior,

        content: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  (icon),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 20,
                width: 16,
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 2,
                )),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Text(
                'Đóng',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        // margin: EdgeInsets.only(bottom: _deviceHight! - 140, right: 40, left: 40),
        duration: duration,
      ),
    );
  }
}
