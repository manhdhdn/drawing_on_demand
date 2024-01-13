import 'package:flutter/material.dart';

import '../../widgets/constant.dart';

class EmptyWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: kPrimaryColor,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      );
}
