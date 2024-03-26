import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'constant.dart';

class Loaders {
  static hideSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

  static customToast({required BuildContext context, required message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Constant.isDarkMode(context)
                  ? Colors.black87
                  : Colors.black54),
          child: Center(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({
    required BuildContext context,
    required title,
    message = "",
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Iconify(
                  Mdi.check_all,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.apply(color: Colors.white)),
                      Text(message,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.apply(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static warningSnackBar({
    required BuildContext context,
    required title,
    message = "",
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Iconify(
                  Ph.circle_wavy_warning_bold,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.apply(color: Colors.white)),
                      Text(message,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.apply(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: CupertinoColors.activeOrange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static errorSnackBar({
    required BuildContext context,
    required title,
    message = "",
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.apply(color: Colors.white)),
                      Text(message,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.apply(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.red.withOpacity(0.7),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
