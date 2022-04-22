import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void showLoadingMessage(BuildContext context) {
  if (Platform.isAndroid) {
    //android
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: const Text('Expere por favor'),
              content: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text('Calculando ruta'),
                    SizedBox(height: 5),
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ));
    return;
  }

  showCupertinoDialog(
      context: context,
      builder: (context) => const CupertinoAlertDialog(
            title: Text('Expere por favor'),
            content: CupertinoActivityIndicator(),
          ));
}
