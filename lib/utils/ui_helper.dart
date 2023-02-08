import 'package:chat_app/utils/constant.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDialog(String title, BuildContext context) {
    AlertDialog loadingDialog = AlertDialog(
      backgroundColor: StandardColorLibrary.kColor4,
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 25,
            ),
            Text(
              title,
              style: const TextStyle(
                color: StandardColorLibrary.kColor6,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) => loadingDialog),
      barrierColor: Colors.transparent,
    );
  }
}
