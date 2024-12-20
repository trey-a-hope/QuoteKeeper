import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationWidget extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationWidget({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text('No'),
              onPressed: () => context.pop(false),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Yes'),
              onPressed: () => context.pop(true),
            ),
          ],
        )
      : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('NO', style: TextStyle(color: Colors.black)),
              onPressed: () => context.pop(false),
            ),
            TextButton(
              child: const Text('YES', style: TextStyle(color: Colors.black)),
              onPressed: () => context.pop(true),
            ),
          ],
        );
}
