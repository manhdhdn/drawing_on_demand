import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'constant.dart';

class NothingYet extends StatelessWidget {
  final bool visible;

  const NothingYet({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Container(
          height: 213,
          width: 269,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/emptyservice.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          'Nothing just yet',
          textAlign: TextAlign.center,
          style: kTextStyle.copyWith(
              color: kNeutralColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
      ],
    ).visible(visible);
  }
}
